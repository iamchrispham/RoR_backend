class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.bigint :reporter_id, null: false
      t.string :reporter_type, null: false, index: true

      t.bigint :reportable_id, null: false
      t.string :reportable_type, null: false, index: true

      t.timestamps null: false
    end

    add_index :reports, [:reporter_id, :reporter_type]
    add_index :reports, [:reportable_id, :reportable_type]
  end
end
