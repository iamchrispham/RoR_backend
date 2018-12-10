class CreateIdentificationTypes < ActiveRecord::Migration
  def change
    create_table :identification_types do |t|
      t.boolean :active, null: false, index: true, default: true
      t.timestamps null: false
    end

    reversible do |dir|
      dir.up do
        IdentificationType.create_translation_table! :name => :string
      end

      dir.down do
        IdentificationType.drop_translation_table!
      end
    end

  end
end
