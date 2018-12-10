class AddImageToAdmins < ActiveRecord::Migration
  def change
    add_attachment :admins, :image
  end
end
