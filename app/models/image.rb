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
          doc=Hash.from_xml(ze.read)["root"]['img']
          if doc.kind_of?(Array)
            doc.each do |img|
              s="build_#{img['type']}".to_sym
              raise "file not correct" unless methods.include? s
              send s, {
                :file=>zf.fopen(img['src']).read,
                :content_type=>'image/png' }
            end
          else
            s="build_#{doc['type']}".to_sym
            raise "file not correct" unless methods.include? s
            send s, {
                :file=>zf.fopen(doc['src']).read,
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

  def to_img request
    hash=%w(
      uy
   ul ux ur
ly lx cx rx ry
   dl dx dr
      dy )
    nill=Magick::Image.new 1,1 do |i|
      i.format='PNG'
      i.background_color = '#0000'
    end
    a=hash.map do |i|
      img=self.send i.to_sym
      if img.nil?
        nill
      else
        Magick::Image.read_inline(Base64.encode64 img.file).first
      end
    end
    hash = Hash[hash.zip(a)]
    d = Magick::Draw.new do
      self.pointsize = 16
      self.font_family = "Arial"
      self.font_weight = Magick::BoldWeight
      self.stroke = 'none'
    end
    text=@string.transform request
    size=d.get_multiline_type_metrics text
    l,a=size.width.ceil,size.height.ceil
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
    w2=offD+offX+w
    h2=offY+offB+h
    w=[w2-hash["uy"].columns,w2-hash["dy"].columns].min/2
    h=[h2-hash["ly"].rows,h2-hash["ry"].rows].min/2
    if w<0
      offX-=w
      offD-=w-1
      w2=[hash["uy"].columns,hash["dy"].columns].max
    end
    if h<0
      offY-=h
      offB-=h-1
      h2=[hash["ly"].rows,hash["ry"].rows].max
    end
    buff=Magick::Image.new w2,h2 do |i|
      i.format='PNG'
      i.background_color = '#0000'
    end
    buff.composite! hash["ul"],offX-hash["ul"].columns,offY-hash["ul"].rows, Magick::OverCompositeOp
    i=offX
    iTime.times do
      buff.composite! hash["ux"],i, offY-hash["ux"].rows, Magick::OverCompositeOp 
      i+=hash["ux"].columns
    end
    buff.composite! hash["ur"],w2 - offD,offY-hash["ur"].rows, Magick::OverCompositeOp
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
      buff.composite! hash["rx"],w2-offD,i, Magick::OverCompositeOp
      i+=hash["rx"].rows
    end
    buff.composite! hash["dl"],offX-hash["dl"].columns,h2-offB, Magick::OverCompositeOp
    i=offX
    lTime.times do
      buff.composite! hash["dx"],i,h2-offB, Magick::OverCompositeOp
      i+=hash["dx"].columns
    end
    buff.composite! hash["dr"],w2-offD,h2-offB, Magick::OverCompositeOp
    buff.composite! hash["uy"],(w2-hash["uy"].columns)/2,offY-hash["uy"].rows-oY, Magick::OverCompositeOp
    buff.composite! hash["ly"],offX-hash["ly"].columns-oX,(h2-hash["ly"].rows)/2, Magick::OverCompositeOp
    buff.composite! hash["ry"],w2-offD+oD,(h2-hash["ry"].rows)/2, Magick::OverCompositeOp
    buff.composite! hash["dy"],(w2-hash["dy"].columns)/2,h2-offB+oB, Magick::OverCompositeOp
    buff.annotate d,w2,h2,offX,offY+16, text # TODO Non stampo i caratteri strani
    buff.to_blob
  end
end
