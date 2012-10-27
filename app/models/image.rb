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
  
  def text= string
    @string=string
  end
  
  def uploaded_pkg= zip
    Zip::Archive.open_buffer(zip.read) do |zf|
      zf.each do |ze|
        if ze.name =~ /\.xml$/
          Hash.from_xml(ze.read)["root"]['img'].each do |img|
            s="build_#{img['type']}".to_sym
            raise "file not correct"+s unless methods.include? s # TODO gestire questa eccezione
            send s, {
              :file=>zf.fopen(img['src']).read,
              :content_type=>'image/png' }
          end
          break
        end
      end
    end
  end
  
  def self.random
    if (c = count) != 0
      find(:first, :offset =>rand(c))
    end
  end

  def to_img
    hash=%w(
      uy
   ul ux ur
ly lx cx rx ry
   dl dx dr
      dy )
    a=hash.map do |i|
      img=self.send i.to_sym
      if img.nil?
        Magick::Image.new 1,1,Magick::HatchFill.new('#0000')
      else
        Magick::Image.read_inline(Base64.encode64 img.file).first
      end
    end
    hash = Hash[hash.zip(a)]
    l,a=100,300 # TODO da ricavare
    mTimeX=(1.0*l/hash["cx"].columns).ceil
    mTimeY=(1.0*a/hash["cx"].rows).ceil
    w=mTimeX*hash["cx"].columns.lcm(hash["dx"].columns.lcm hash["ux"].columns)
    h=mTimeY*hash["cx"].rows.lcm( hash["lx"].rows.lcm hash["rx"].rows)
    mTimeX=w/hash["cx"].columns
    mTimeY=h/hash["cx"].rows
    iTime=w/hash["ux"].columns
    lTime=w/hash["dx"].columns
    jTime=h/hash["lx"].rows
    kTime=h/hash["rx"].rows
    oY=[[hash["ul"].rows,hash["ux"].rows].max,hash["ur"].rows].max
    oB=[[hash["dl"].rows,hash["dx"].rows].max,hash["dr"].rows].max
    oX=[[hash["ul"].columns,hash["lx"].columns].max,hash["dl"].columns].max
    oD=[[hash["ur"].columns,hash["rx"].columns].max,hash["dr"].columns].max
    offY=oY+hash["uy"].rows
    offB=oB+hash["dy"].rows
    offX=oX+hash["ly"].columns
    offD=oD+hash["ry"].columns
    w+=offD+offX
    h+=offY+offB
    w=[w-hash["uy"].columns,w-hash["dy"].columns].min/2
    h=[h-hash["ly"].rows,h-hash["ry"].rows].min/2
    if w<0
      offX-=w
      offD-=w-1
      w=[hash["uy"].columns,hash["dy"].columns].max
    end
    if h<0
      offY-=h
      offB-=h-1
      h=[hash["ly"].rows,hash["ry"].rows].max
    end
    buff=Magick::Image.new w,h,Magick::HatchFill.new('#0000')
    buff.composite! hash["ul"],offX-hash["ul"].columns,offY-hash["ul"].rows, Magick::OverCompositeOp
    i=offX
    iTime.times do
      buff.composite! hash["ux"],i, offY-hash["ux"].rows, Magick::OverCompositeOp 
      i+=hash["ux"].columns
    end
    buff.composite! hash["ur"],w- offD,offY-hash["ur"].rows, Magick::OverCompositeOp
    i=offY
    jTime.times do
      buff.composite! hash["lx"],offX-hash["lx"].columns,i, Magick::OverCompositeOp
      i+=hash["lx"].rows
    end
    i=offX
    mTimeX.times do
      j=offY
      mTimeY.times do
        buff.composite! hash["cx"],i,j, Magick::OverCompositeOp
        j+=hash["cx"].rows
      end
      i+=hash["cx"].columns
    end
    i=offY
    kTime.times do
      buff.composite! hash["rx"],w-offD,i, Magick::OverCompositeOp
      i+=hash["rx"].rows
    end
    buff.composite! hash["dl"],offX-hash["dl"].columns,h-offB, Magick::OverCompositeOp
    i=offX
    lTime.times do
      buff.composite! hash["dx"],i,h-offB, Magick::OverCompositeOp
      i+=hash["dx"].columns
    end
    buff.composite! hash["dr"],w-offD,h-offB, Magick::OverCompositeOp
    buff.composite! hash["uy"],(w-hash["uy"].columns)/2,offY-hash["uy"].rows-oY, Magick::OverCompositeOp
    buff.composite! hash["ly"],offX-hash["ly"].columns-oX,(h-hash["ly"].rows)/2, Magick::OverCompositeOp
    buff.composite! hash["ry"],w-offD+oD,(h-hash["ry"].rows)/2, Magick::OverCompositeOp
    buff.composite! hash["dy"],(w-hash["dy"].columns)/2,h-offB+oB, Magick::OverCompositeOp
    # TODO scrivere testo
    buff.format='PNG'
    buff.to_blob
  end
end
