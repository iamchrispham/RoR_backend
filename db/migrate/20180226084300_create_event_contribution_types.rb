class CreateEventContributionTypes < ActiveRecord::Migration
  def change
    create_table :event_contribution_types do |t|
      t.string :name, null: false
      t.string :slug, null: false

      t.string :cta_title, null: false
      t.text :cta_description, null: false

      t.string :change_amount_title, null: false
      t.text :change_amount_description, null: false

      t.boolean :active, null: false, index: true, default: true

      t.timestamps null: false
    end
  end
end
