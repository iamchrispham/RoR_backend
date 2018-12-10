class AddCoverImageToUsers < ActiveRecord::Migration
  def change
    add_attachment :users, :cover_image
  end
end
