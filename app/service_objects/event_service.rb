class EventService < ApiService
  include Api::CacheHelper
  include ActionView::Helpers::NumberHelper

  def create(params, current_api_user)
    event = event_for_params(params, current_api_user)

    contribution_details_params = params[:contribution_details]
    if contribution_details_params.present?
      amount_cents = contribution_details_params[:amount_cents]
      minimum_amount = ENV.fetch('EVENT_CONTRIBUTION_MINIMUM_AMOUNT', 1000).to_i
      if amount_cents < minimum_amount
        register_error(Showoff::ResponseCodes::INVALID_ARGUMENT, I18n.t('api.responses.events.minimum_contribution', total_amount: formatted_total_amount(minimum_amount, current_api_user)))
        return
      end
    end


    media_items = params[:media_items]
    minimum_media_count = 1
    if media_items.nil? || media_items.length < minimum_media_count
      register_error(Showoff::ResponseCodes::INVALID_ARGUMENT, I18n.t('api.responses.events.minimum_number_of_media_items', count: minimum_media_count))
    elsif event.present? && event.valid?
      event.save!

      # save contribution details
      if contribution_details_params.present?
        event_contribution_detail = EventContributionDetail.new(contribution_details_params.except(:event_contribution_type))
        event_contribution_detail.event = event
        event_contribution_detail.event_contribution_type = EventContributionType.find_by(slug: contribution_details_params[:event_contribution_type])
        event_contribution_detail.active = true

        if event_contribution_detail.valid?
          event_contribution_detail.save!
        else
          register_error(Showoff::ResponseCodes::INVALID_ARGUMENT, event_contribution_detail.errors.full_messages.first)
          event.destroy!
          return
        end
      end

      # save ticket details
      ticket_details_params = params[:ticket_details]
      if ticket_details_params.present?
        event_ticket_detail = EventTicketDetail.new(ticket_details_params)
        event_ticket_detail.event = event
        event_ticket_detail.active = true

        if event_ticket_detail.valid?
          event_ticket_detail.save!
        else
          register_error(Showoff::ResponseCodes::INVALID_ARGUMENT, event_ticket_detail.errors.full_messages.first)
          event.destroy!
          return
        end
      end

      # create attendance for the event owner
      attendee = event.event_attendees.new(status: EventAttendee.statuses[:going])
      attendee.user = current_api_user
      if attendee.valid?
        attendee.save!
      else
        register_error(Showoff::ResponseCodes::INVALID_ARGUMENT, attendee.errors.full_messages.first)
        event.destroy!
        return
      end

      # save media items
      save_media_items(event, media_items)

      event
    elsif event.present?
      register_error(Showoff::ResponseCodes::INVALID_ARGUMENT, event.errors.full_messages.first)
    else
      register_error(Showoff::ResponseCodes::INVALID_ARGUMENT, I18n.t('api.responses.internal_error'))
    end
  end

  def update(event, params)
    attendees = params[:attendees]

    # check maximum attendees
    maximum_attendees = params[:maximum_attendees]
    maximum_attendees = nil if maximum_attendees.present? && maximum_attendees.to_i == -1

    if maximum_attendees.present? && maximum_attendees.to_i < event.attending_users.count
      register_error(Showoff::ResponseCodes::MISSING_ARGUMENT, I18n.t('api.responses.events.already_more_attending_than_cap'))
      return nil
    end
    maximum_attendees = event.maximum_attendees if params[:maximum_attendees].blank?

    # set up base params
    base_params = params.except(:attendees, :media_items, :time, :date, :contribution_details, :maximum_attendees, :invite_all_friends, :ticket_details)

    base_params.delete(:private_event) if event.private_event

    if event.update_attributes(base_params)

      event.maximum_attendees = maximum_attendees
      event.time = Time.at(params[:time]) if params[:time].present?
      event.date = Time.at(params[:date]) if params[:date].present?

      attendees = event.user.friends.active.pluck(:id) if params[:invite_all_friends]

      # save attendees
      unless attendees.blank?
        attendees.each do |attendee|
          next if current_api_user.id == attendee
          user = User.find_by(id: attendee)
          next if user.blank? || event.event_attendees.find_by(user: user)
          event.event_attendees << EventAttendee.new(user: user, event: event, invited: true, status: EventAttendee.statuses[:invited])
        end
      end

      event.save!

      # save contribution details
      contribution_details_params = params[:contribution_details]

      if contribution_details_params.present?
        amount_cents = contribution_details_params[:amount_cents]
        minimum_amount = ENV.fetch('EVENT_CONTRIBUTION_MINIMUM_AMOUNT', 1000).to_i
        if amount_cents < minimum_amount
          register_error(Showoff::ResponseCodes::INVALID_ARGUMENT, I18n.t('api.responses.events.minimum_contribution', total_amount: formatted_total_amount(minimum_amount, current_api_user)))
          return
        end
      end

      if event.event_contribution_detail.blank? && contribution_details_params.present?
        event_contribution_detail = EventContributionDetail.new(contribution_details_params.except(:event_contribution_type))
        event_contribution_detail.event = event
        event_contribution_detail.event_contribution_type = EventContributionType.find_by(slug: contribution_details_params[:event_contribution_type])
        event_contribution_detail.active = true

        if event_contribution_detail.valid?
          event_contribution_detail.save!
        else
          register_error(Showoff::ResponseCodes::INVALID_ARGUMENT, event_contribution_detail.errors.full_messages.first)
          return
        end
      elsif contribution_details_params.present? && event.event_contribution_detail.present?
        event_contribution_detail = event.event_contribution_detail
        if event_contribution_detail.update_attributes(contribution_details_params.except(:event_contribution_type))
          event_contribution_detail.event_contribution_type = EventContributionType.find_by(slug: contribution_details_params[:event_contribution_type])
          if event_contribution_detail.valid?
            event_contribution_detail.active = true
            event_contribution_detail.save!
          else
            register_error(Showoff::ResponseCodes::INVALID_ARGUMENT, event_contribution_detail.errors.full_messages.first)
            return
          end
        else
          register_error(Showoff::ResponseCodes::INVALID_ARGUMENT, event_contribution_detail.errors.full_messages.first)
          return
        end
      elsif event.event_contribution_detail.present? && !params.has_key?(:invite_all_friends)
        event.event_contribution_detail.deactivate!
      end

      # save ticket details
      ticket_details_params = params[:ticket_details]
      if event.event_ticket_detail.blank? && ticket_details_params.present?
        event_ticket_detail = EventTicketDetail.new(ticket_details_params)
        event_ticket_detail.event = event
        event_ticket_detail.active = true

        if event_ticket_detail.valid?
          event_ticket_detail.save!
        else
          register_error(Showoff::ResponseCodes::INVALID_ARGUMENT, event_ticket_detail.errors.full_messages.first)
          return
        end
      elsif ticket_details_params.present? && event.event_ticket_detail.present?
        event_ticket_detail = event.event_ticket_detail
        if event_ticket_detail.update_attributes(ticket_details_params)
          if event_ticket_detail.valid?
            event_ticket_detail.active = true
            event_ticket_detail.save!
          else
            register_error(Showoff::ResponseCodes::INVALID_ARGUMENT, event_ticket_detail.errors.full_messages.first)
            return
          end
        else
          register_error(Showoff::ResponseCodes::INVALID_ARGUMENT, event_ticket_detail.errors.full_messages.first)
          return
        end
      elsif event.event_ticket_detail.present? && !params.has_key?(:invite_all_friends)
        event.event_ticket_detail.deactivate!
      end

      # save media items
      media_items = params[:media_items]
      minimum_media_count = 1
      if media_items.present? && media_items.length < minimum_media_count
        register_error(Showoff::ResponseCodes::INVALID_ARGUMENT, I18n.t('api.responses.events.minimum_number_of_media_items', count: minimum_media_count))
      elsif media_items.present?
        update_media_items(event, media_items)
      end

      event
    else
      register_error(Showoff::ResponseCodes::INVALID_ARGUMENT, event.errors.full_messages.first)
    end
  end

  private

  def update_media_items(event, media_items)
    event.event_media_items.destroy_all
    save_media_items(event, media_items)
  end


  def save_media_items(event, media_items)
    media_items.each do |source|
      source = source.with_indifferent_access

      type = source[:type]
      next unless valid_sources.include? type
      url = source[:url]
      next unless url.present?

      # process media item
      media_item = EventMediaItem.new(event: event)
      media_item.uploaded_url = url
      media_item.media_type = type

      if media_item.valid?
        media_item.save!

        case type
        when 'video'
          Showoff::Workers::ImageWorker.perform_async(media_item.class.to_s,  media_item.id, { url: url }, :video)
        when 'image'
          Showoff::Workers::ImageWorker.perform_async(media_item.class.to_s,  media_item.id, url: url)
        end
      else
        register_error(Showoff::ResponseCodes::INVALID_ARGUMENT, media_item.errors.full_messages.first)
        break
      end
    end
  end

  def valid_sources
    %w[video image]
  end

  def formatted_total_amount(total_amount_cents, user)
    number_to_currency(total_amount_cents / 100, unit: user.currency.symbol)
  end

  def event_for_params(params, current_api_user)
    attendees = params[:attendees]

    # set up event object
    base_params = params.except(:attendees, :media_items, :time, :date, :contribution_details, :invite_all_friends, :ticket_details)
    event = current_api_user.events.new(base_params)

    event.time = Time.at(params[:time]) if params[:time].present?
    event.date = Time.at(params[:date]) if params[:date].present?

    attendees = current_api_user.friends.active.pluck(:id) if params[:invite_all_friends]

    # save attendees
    unless attendees.blank?
      attendees.each do |attendee|
        next if current_api_user.id == attendee
        user = User.find_by(id: attendee)
        next if user.blank?
        event.event_attendees << EventAttendee.new(user: user, event: event, invited: true, status: EventAttendee.statuses[:invited])
      end
    end

    event
  end
end
