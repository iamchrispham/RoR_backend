class ShowoffSnsCreateNotifierExampleNotifiers < ActiveRecord::Migration
  def change
    create_table :example_notifiers do |t|
      t.belongs_to :showoff_sns_notification, index: { name: :index_example_notifiers_on_notification }, foreign_key: true

      t.timestamps null: false
    end
  end
end
