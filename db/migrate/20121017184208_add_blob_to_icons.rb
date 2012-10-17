class AddBlobToIcons < ActiveRecord::Migration
  def up
    add_column :icons, :blob_id, :integer

  end
end
