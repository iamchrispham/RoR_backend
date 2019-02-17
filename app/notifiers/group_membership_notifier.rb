class GroupMembershipNotifier < Showoff::SNS::Notifier::Base
  belongs_to :membership

  validates :membership, presence: true

  after_commit :send_notification, on: :create

  def set_owner
    self.owner = membership.group.owner
  end

  def self.notification_type
    :group_membership
  end

  def subscribers
    [membership.user]
  end

  def message(_target)
    if membership.active?
      I18n.t('notifiers.group_membership.accepted.message',
             user: membership.group.owner.name,
             group_category: membership.group.category,
             group: membership.group.name)
    end
  end

  def extra_information(_target)
    {
      membership_id: membership.id,
      group_id: membership.group_id,
      user_id: membership.user_id
    }
  end

  def resources(target)
    {
      group_membership: serialized_resource(membership, ::Groups::MembershipSerializer),
      group: membership.group.cached(target, type: :feed)
    }
  end
end
