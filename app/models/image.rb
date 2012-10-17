class Image < ActiveRecord::Base
  belongs_to :user
  belongs_to :uy, :class_name=>"Blob", :foreign_key=>"uy_id"
  belongs_to :us, :class_name=>"Blob", :foreign_key=>"us_id"
  belongs_to :ux, :class_name=>"Blob", :foreign_key=>"ux_id"
  belongs_to :ud, :class_name=>"Blob", :foreign_key=>"ud_id"
  belongs_to :sy, :class_name=>"Blob", :foreign_key=>"sy_id"
  belongs_to :lx, :class_name=>"Blob", :foreign_key=>"lx_id"
  belongs_to :cx, :class_name=>"Blob", :foreign_key=>"cx_id"
  belongs_to :rx, :class_name=>"Blob", :foreign_key=>"rx_id"
  belongs_to :ry, :class_name=>"Blob", :foreign_key=>"ry_id"
  belongs_to :ds, :class_name=>"Blob", :foreign_key=>"ds_id"
  belongs_to :dx, :class_name=>"Blob", :foreign_key=>"dx_id"
  belongs_to :dr, :class_name=>"Blob", :foreign_key=>"dr_id"
  belongs_to :dy, :class_name=>"Blob", :foreign_key=>"dy_id"
  def self.random
    if (c = count) != 0
      find(:first, :offset =>rand(c))
    end
  end
end
=begin
       uy
   us ux ud
sy lx cx rx ry
   ds dx dr
      dy 
=end