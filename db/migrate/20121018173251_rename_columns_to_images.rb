class RenameColumnsToImages < ActiveRecord::Migration
  def change
    rename_column :images, :us_id, :ul_id
    rename_column :images, :ud_id, :ur_id
    rename_column :images, :sy_id, :ly_id
    rename_column :images, :ds_id, :dl_id
  end
end
