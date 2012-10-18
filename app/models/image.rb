class Image < ActiveRecord::Base
  belongs_to :user
  belongs_to :uy, :class_name=>"Blob", :foreign_key=>"uy_id"
  belongs_to :ul, :class_name=>"Blob", :foreign_key=>"ul_id"
  belongs_to :ux, :class_name=>"Blob", :foreign_key=>"ux_id"
  belongs_to :ur, :class_name=>"Blob", :foreign_key=>"ur_id"
  belongs_to :ly, :class_name=>"Blob", :foreign_key=>"ly_id"
  belongs_to :lx, :class_name=>"Blob", :foreign_key=>"lx_id"
  belongs_to :cx, :class_name=>"Blob", :foreign_key=>"cx_id"
  belongs_to :rx, :class_name=>"Blob", :foreign_key=>"rx_id"
  belongs_to :ry, :class_name=>"Blob", :foreign_key=>"ry_id"
  belongs_to :dl, :class_name=>"Blob", :foreign_key=>"dl_id"
  belongs_to :dx, :class_name=>"Blob", :foreign_key=>"dx_id"
  belongs_to :dr, :class_name=>"Blob", :foreign_key=>"dr_id"
  belongs_to :dy, :class_name=>"Blob", :foreign_key=>"dy_id"
  
# probabilmente non servirà a nulla, ma intanto l'ho fatto
  def method_missing s,*a,&b
    @parent.send s unless s =~ /^uploaded_data_(.{2})=/ 
    s="build_#{$1}".to_sym
    send s, {
      :file=>a[0].read,
      :content_type=>a[0].content_type.chomp }
  end
  
  def self.random
    if (c = count) != 0
      find(:first, :offset =>rand(c))
    end
  end
end
=begin
       uy
   ul ux ur
ly lx cx rx ry
   dl dx dr
      dy 
=end