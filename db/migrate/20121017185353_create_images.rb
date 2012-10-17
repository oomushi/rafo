class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :uy_id
      t.integer :us_id
      t.integer :ux_id
      t.integer :ud_id
      t.integer :sy_id
      t.integer :lx_id
      t.integer :cx_id
      t.integer :rx_id
      t.integer :ry_id
      t.integer :ds_id
      t.integer :dx_id
      t.integer :dr_id
      t.integer :dy_id

      t.timestamps
    end
  end
end
