class CreateUserTags < ActiveRecord::Migration
  def change
    create_table :user_tags do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.references :tag, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
