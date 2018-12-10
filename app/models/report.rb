class Report < ActiveRecord::Base
  include Periodable

  belongs_to :reportable, polymorphic: true
  belongs_to :reporter, polymorphic: true

  validates :reportable_id, uniqueness: { scope: [:reportable_type, :reporter_id, :reportable_type] }
  validates :reportable, :reporter, presence: true

  after_commit :call_reportable_reported_action, on: :create

  scope :unconsidered, -> { where(considered: false) }

  enum reason: [:unspecified, :inappropriate, :spam]

  private

  def call_reportable_reported_action
    reportable.reported_action if reportable.respond_to?(:reported_action)
  end

  after_create :update_caches
  before_destroy :update_caches
  def update_caches
    if reportable.respond_to? :update_caches
      reportable.update_caches
    end
  end
end
