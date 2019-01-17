class EventContributionDetail < ActiveRecord::Base
  include Indestructable
  include ActionView::Helpers::NumberHelper

  has_paper_trail

  belongs_to :event
  belongs_to :event_contribution_type

  monetize :amount_cents, with_currency: lambda {|obj| obj.event.user.currency}

  validates :event, :event_contribution_type, presence: true

  validates :amount_cents, presence: true

  def go_fee_cents
    amount_cents * go_percentage
  end

  def go_percentage
    ENV.fetch('GO_PERCENTAGE', 0.129).to_f
  end

  def total_amount_cents
    # NOTE: This may change back to this depedning on what client requires in v1.1
    # amount_cents + go_fee_cents
    amount_cents
  end

  def calculate_price(amount_cents)
    # NOTE: This may change back to this depending on what client requires in v1.1
    # amount_cents + (amount_cents * go_percentage)

    amount_cents
  end

  def cta_description
    I18n.t("api.responses.events.attendees.contributions.types.#{event_contribution_type.slug}.cta_description", total_amount: formatted_total_amount(total_amount_cents), host: event.user.name)
  end

  def cta_description_for_price(amount_cents)
    I18n.t("api.responses.events.attendees.contributions.types.#{event_contribution_type.slug}.cta_description_optional", total_amount: formatted_total_amount(amount_cents), host: event.user.name)
  end

  def formatted_total_amount(total_amount_cents)
    number_to_currency(total_amount_cents / 100, unit: amount.currency.symbol)
  end

end
