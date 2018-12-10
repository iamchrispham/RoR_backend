class ShowoffSnsCreateNotifiableExampleNotifiables < ActiveRecord::Migration
  def change
    create_table :example_notifiables do |t|
  
      t.timestamps null: false
    end
  end
end
