class GroupInvitationNotifier < Showoff::SNS::Notifier::Base
  belongs_to :group_invitation

  validates :group_invitation, uniqueness: true, presence: true

  after_commit :send_notification, on: :create

  def set_owner
    self.owner = group_invitation.user
  end

  def self.notification_type
    :group_invitation
  end

  def subscribers
    [group_invitation.user]
  end

  def message(_target)
    I18n.t('notifiers.group_invitation.message',
           user: group_invitation.user.name,
           group: group_invitation.group.name)
  end

  def extra_information(_target)
    {
      group_invitation_id: group_invitation.id,
      group_id: group_invitation.group_id,
      user_id: group_invitation.user_id
    }
  end

  def should_notify?(target)
    target.notifications_enabled_for('group_invitation')
  end

  def resources(target)
    {
      group_invitation: serialized_resource(group_invitation, ::Group::Invitation::OverviewSerializer, user: target),
      group: group_invitation.group.cached(target, type: :feed)
    }
  end
end
