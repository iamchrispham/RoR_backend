class AddTaggedAttributeToTaggedObjects < ActiveRecord::Migration
  def change
    add_belongs_to :tagged_objects, :tagged_attribute, null: false, index: true
  end
end
