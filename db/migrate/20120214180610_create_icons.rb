class CreateIcons < ActiveRecord::Migration
  def change
    create_table :icons do |t|
      t.integer :user_id
      t.string :content_type
      t.binary :file

      t.timestamps
    end
  end
end
