class RemoveContentTypeToIcons < ActiveRecord::Migration
  def up
    Icon.all.each do |icon|
      icon.blob=Blob.create({:file=>icon.file, :content_type=>icon.content_type})
      icon.save
    end
    remove_column :icons, :content_type
    remove_column :icons, :file
  end

  def down
    add_column :icons, :file, :binary
    add_column :icons, :content_type, :string
    Icon.all.each do |icon|
      icon.content_type=icon.blob.content_type
      icon.file=icon.blob.file
      icon.save
    end
  end
end
