class CreateBlobs < ActiveRecord::Migration
  def change
    create_table :blobs do |t|
      t.string :content_type
      t.binary :file

      t.timestamps
    end
  end
end
