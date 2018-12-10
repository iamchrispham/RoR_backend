class CreateEventContributionDetails < ActiveRecord::Migration
  def change
    create_table :event_contribution_details do |t|
      t.references :event, index: true, foreign_key: true
      t.references :event_contribution_type, index: true, foreign_key: true

      t.monetize :amount, currency: { present: false }, index: true

      t.text :reason
      t.boolean :optional, null: false, index: true

      t.timestamps null: false
    end
  end
end
