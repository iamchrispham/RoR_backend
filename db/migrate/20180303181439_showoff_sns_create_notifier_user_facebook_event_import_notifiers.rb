class ShowoffSnsCreateNotifierUserFacebookEventImportNotifiers < ActiveRecord::Migration
  def change
    create_table :user_facebook_event_import_notifiers do |t|
      t.belongs_to :showoff_sns_notification, index: {name: :index_user_facebook_event_import_notifiers_on_notification}, foreign_key: true, null: false
      t.references :user_facebook_event_import, null: false, index: {name: :index_user_facebook_event_on_user_facebook_event_impor}, foreign_key: true

      t.string :owner_type, null: false, index: true
      t.bigint :owner_id, null: false, index: true
      t.timestamps null: false
    end

    add_index :user_facebook_event_import_notifiers, [:owner_id, :owner_type], name: :index_user_facebook_event_import_notifiers_on_owner
  end
end
