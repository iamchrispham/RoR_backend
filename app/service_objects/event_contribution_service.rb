class EventContributionService < ApiService
  include Api::CacheHelper
  include ActionView::Helpers::NumberHelper

  def price(attendee, params)
    if attendee.blank?
      register_error(Showoff::ResponseCodes::MISSING_ARGUMENT, I18n.t('api.responses.missing_parameter', param: 'attendee'))
      return
    end

    if params.blank?
      register_error(Showoff::ResponseCodes::MISSING_ARGUMENT, I18n.t('api.responses.missing_parameter', param: 'params'))
      return
    end

    if attendee.contribution.present?
      register_error(Showoff::ResponseCodes::MISSING_ARGUMENT, I18n.t('api.responses.events.attendees.contributions.already_contributed'))
      return
    end

    # check we have an amount
    amount_cents = params[:amount_cents]
    if amount_cents.blank?
      register_error(Showoff::ResponseCodes::MISSING_ARGUMENT, I18n.t('api.responses.events.attendees.contributions.totals.required'))
      return
    end

    minimum_amount = ENV.fetch('EVENT_CONTRIBUTION_MINIMUM_AMOUNT', 1000).to_i
    if amount_cents < minimum_amount
      register_error(Showoff::ResponseCodes::INVALID_ARGUMENT, I18n.t('api.responses.events.minimum_contribution', total_amount: formatted_total_amount(minimum_amount, attendee.event.event_owner)))
      return
    end

    amount_cents = amount_cents.to_i

    total_amount_cents = attendee.event.event_contribution_detail.calculate_price(amount_cents)
    {
        amount: {
            cents: total_amount_cents,
            currency: serialized_resource(attendee.event.event_contribution_detail.amount.currency, ::Countries::Currencies::OverviewSerializer)
        },
        message: attendee.event.event_contribution_detail.cta_description_for_price(total_amount_cents)
    }
  end

  def create(attendee, params)
    if attendee.blank?
      register_error(Showoff::ResponseCodes::MISSING_ARGUMENT, I18n.t('api.responses.missing_parameter', param: 'attendee'))
      return
    end

    if params.blank?
      register_error(Showoff::ResponseCodes::MISSING_ARGUMENT, I18n.t('api.responses.missing_parameter', param: 'params'))
      return
    end

    if attendee.contribution.present?
      register_error(Showoff::ResponseCodes::MISSING_ARGUMENT, I18n.t('api.responses.events.attendees.contributions.already_contributed'))
      return
    end

    # check we have an amount
    amount_cents = params[:amount_cents]
    if amount_cents.blank?
      register_error(Showoff::ResponseCodes::MISSING_ARGUMENT, I18n.t('api.responses.events.attendees.contributions.totals.required'))
      return
    end
    amount_cents = amount_cents.to_i

    minimum_amount = ENV.fetch('EVENT_CONTRIBUTION_MINIMUM_AMOUNT', 1000).to_i
    if amount_cents < minimum_amount
      register_error(Showoff::ResponseCodes::INVALID_ARGUMENT, I18n.t('api.responses.events.minimum_contribution', total_amount: formatted_total_amount(minimum_amount, attendee.event.event_owner)))
      return
    end

    # check if user has valid card
    begin
      payment_service = payment_service(attendee)
      if payment_service.sources.size.zero?
        register_error(Showoff::ResponseCodes::USER_NO_CREDIT_CARD_PRESENT, I18n.t('api.responses.users.payments.no_credit_card'))
        return
      end
    rescue StandardError => e
      report_error(e)

      register_error(Showoff::ResponseCodes::INVALID_ARGUMENT, e.message)
      return
    end

    # create the contribution
    attendee_contribution = attendee.event_attendee_contributions.create(
        amount_cents: amount_cents,
        status: EventAttendeeContribution.statuses[:pending]
    )

    # try charge customer
    begin
      # Ensure service fee cannot be less than 0
      service_fee = service_fee_cents(amount_cents).to_i

      # NOTE: This may change back to this depending on what client requires in v1.1
      # total_amount_cents = amount_cents + service_fee

      # try charge card
      payment_service(attendee).charge(
          # NOTE: This may change back to this depending on what client requires in v1.1
          # amount: total_amount_cents,
          amount: amount_cents,
          purchase: attendee_contribution,
          currency: attendee_contribution.amount.currency.iso_code,
          application_fee: service_fee
      )

      attendee_contribution.paid!
    rescue Showoff::Payments::Errors::CardError => e
      report_error(e)

      # delete attendee contribution
      attendee_contribution.delete

      register_error(Showoff::ResponseCodes::INVALID_ARGUMENT, I18n.t('api.responses.events.attendees.contributions.payments.payment_failed'))
      return
    rescue Showoff::Payments::Errors::PaymentError => e
      report_error(e)

      # delete attendee contribution
      attendee_contribution.delete

      register_error(Showoff::ResponseCodes::INVALID_ARGUMENT, I18n.t('api.responses.events.attendees.contributions.payments.payment_failed_generic'))
      return
    rescue StandardError => e
      report_error(e)

      # delete attendee contribution
      attendee_contribution.delete

      register_error(Showoff::ResponseCodes::INVALID_ARGUMENT, I18n.t('api.responses.events.attendees.contributions.payments.payment_failed_generic'))
      return
    end

    attendee_contribution
  end

  private

  def formatted_total_amount(total_amount_cents, user)
    number_to_currency(total_amount_cents / 100, unit: user.currency.symbol)
  end

  def service_fee_cents(total_cents)
    total_cents * go_percentage
  end

  def go_percentage
    ENV.fetch('GO_PERCENTAGE', 0.129).to_f
  end

  def payment_service(attendee)
    @payment_service ||= Showoff::Payments::Services::PaymentService.new(customer: attendee.user, vendor: attendee.event.event_owner)
  end
end
