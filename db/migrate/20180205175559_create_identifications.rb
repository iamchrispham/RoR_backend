class CreateIdentifications < ActiveRecord::Migration
  def change
    create_table :identifications do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.attachment :front_image
      t.attachment :back_image
      t.references :identification_type, index: true, foreign_key: true, null: false
      t.boolean :pending_verification, index: true, default: true
      t.boolean :verified, index: true, default: false
      t.timestamp :verified_at
      t.string :verifier_type
      t.string :verifier_id

      t.timestamps null: false
    end

    add_index :identifications, [:verifier_id, :verifier_type]
  end
end
