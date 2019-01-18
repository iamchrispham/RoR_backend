class MakeEventsPolymorphic < ActiveRecord::Migration
  def change
    add_column :events, :event_ownerable_id, :integer, allow_nil: false
    add_column :events, :event_ownerable_type, :string, allow_nil: false

    add_index :events, [:event_ownerable_id, :event_ownerable_type]

    Event.where.not(user_id: nil).each do |event|
      event.update(event_ownerable_id: event.user_id, event_ownerable_type: 'User')
    end

    remove_column :events, :user_id, :integer
  end
end
