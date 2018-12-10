class CreateContactInvites < ActiveRecord::Migration
  def change
    create_table :contact_invites do |t|
      t.belongs_to :user, null: false, index: true
      t.belongs_to :event, index: true
      t.belongs_to :go_user, index: true

      t.string :email, index: true
      t.string :phone_number, index: true
      t.string :name, index: true

      t.timestamps null: false
    end

    add_index :contact_invites, [:user_id, :go_user_id, :event_id, :email, :phone_number], unique: true, name: :idx_contact_invite_unique
  end
end
