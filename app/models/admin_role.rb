class AdminRole < ActiveRecord::Base
  has_and_belongs_to_many :admins, join_table: :admins_admin_roles

  belongs_to :resource, polymorphic: true
  validates :resource_type, inclusion: {in: Rolify.resource_types}, allow_nil: true

  scopify

  def self.options_for_select
    [
        [I18n.t('models.admin_roles.types.admin'), :admin],
        [I18n.t('models.admin_roles.types.sales'), :sales],
        [I18n.t('models.admin_roles.types.help_desk'), :help_desk],
    ]
  end
end
