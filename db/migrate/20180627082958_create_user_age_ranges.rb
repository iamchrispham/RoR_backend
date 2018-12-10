class CreateUserAgeRanges < ActiveRecord::Migration
  def change
    create_table :user_age_ranges do |t|
      t.integer :start_age, null: false
      t.integer :end_age, null: false
      t.boolean :active, null: false, index: true, default: true

      t.timestamps null: false
    end

    reversible do |dir|
      dir.up do
        UserAgeRange.create_translation_table! name: :string
      end

      dir.down do
        UserAgeRange.drop_translation_table!
      end
    end

  end
end
