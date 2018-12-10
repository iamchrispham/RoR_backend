class Identification < ActiveRecord::Base
  has_paper_trail

  include Indestructable
  include Identifications::Filterable

  scope :verified, -> { where(verified: true) }
  scope :pending_verification, -> { where(pending_verification: true) }
  scope :rejected, -> { where(pending_verification: false, verified: false) }
  scope :pending_verification_or_verified, -> { verified.or(pending_verification) }

  belongs_to :verifier, polymorphic: true
  belongs_to :identification_type
  belongs_to :user

  has_attached_file :front_image,
                    styles: { small: '100x100>', medium: '200x200>', large: '400x400>' },
                    default_url: "https://#{ENV['AWS_BUCKET']}.s3.amazonaws.com/:class/:attachment/missing/missing.jpg",
                    url: ':s3_domain_url',
                    path: ':class/:attachment/:hash.:extension',
                    hash_secret: ENV['SECRET_KEY_BASE']
  validates_attachment_content_type :front_image, content_type: /\Aimage\/.*\Z/

  has_attached_file :back_image,
                    styles: { small: '100x100>', medium: '200x200>', large: '400x400>' },
                    default_url: "https://#{ENV['AWS_BUCKET']}.s3.amazonaws.com/:class/:attachment/missing/missing.jpg",
                    url: ':s3_domain_url',
                    path: ':class/:attachment/:hash.:extension',
                    hash_secret: ENV['SECRET_KEY_BASE']
  validates_attachment_content_type :back_image, content_type: /\Aimage\/.*\Z/

  validates :user, :identification_type, :identification_number, presence: true

  scope :for_term, ->(text) {
    joins(:user).where("users.email ILIKE ? OR users.first_name || ' ' || users.last_name ILIKE ?", "%#{text}%", "%#{text}%")
  }

  scope :for_type, ->(type_id) {
    where(identification_type_id: type_id)
  }

  scope :ordered_by_user_name, -> {
    joins(:user).ordered_by_name
  }

  after_save :update_caches
  after_destroy :update_caches

  def update_caches
    user&.update_caches
  end

  #image helpers
  def front_images
    { small_url: front_image.url(:small), medium_url: front_image.url(:medium), large_url: front_image.url(:large), original_url: front_image.url }
  end

  def back_images
    { small_url: back_image.url(:small), medium_url: back_image.url(:medium), large_url: back_image.url(:large), original_url: back_image.url }
  end

  def front_url
    front_image.url
  end

  def back_url
    back_image.url
  end

  #country
  def country
    @county ||= ISO3166::Country.find_country_by_alpha2(country_of_issue)
  end

  #actions
  def verify(verifier)
    update_attributes(verifier: verifier, verified: true, verified_at: Time.now, pending_verification: false)
  end

  def reject(verifier)
    update_attributes(verifier: verifier, verified: false, verified_at: Time.now, pending_verification: false)
  end

  def reset!
    update_attributes(verifier: nil, verified: false, verified_at: nil, pending_verification: true)
  end

  def status
    return :rejected if !verified && !pending_verification
    return :verified if verified && !pending_verification
    return :pending if !verified && pending_verification
  end

  def status_class
    case status
      when :rejected
        'danger'
      when :verified
        'success'
      when :pending
        'warning'
    end
  end

  def verified?
    status == :verified
  end

  def rejected?
    status == :rejected
  end

  def pending?
    status == :pending
  end

  def record_view(_viewer)
  end

end
