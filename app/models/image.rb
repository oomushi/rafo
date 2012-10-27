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
    hash.map! do |i|
      img=self.send i.to_sym
      if img.nil?
        Magick::Image.new 1,1,Magick::HatchFill.new('#0000')
      else
        Magick::Image.read_inline(Base64.encode64 img.file).first
      end
    end
    l,a=100,50 # TODO da ricavare
    mTimeX=(1.0*l/hash[:cx].columns).ceil
    mTimeY=(1.0*l/hash[:cx].rows).ceil
    w=mTimeX*hash["cx"].columns.lcm(hash["dx"].columns.lcm hash["ux"].columns)
    h=mTimeY*hash["cx"].rows.lcm( hash["lx"].rows.lcm hash["rx"].rows)
    mTimeX=w/hash["cx"].columns
    mTimeY=h/hash["cx"].rows
    iTime=w/hash["ux"].columns
    lTime=w/hash["dx"].columns
    jTime=h/hash["lx"].rows
    kTime=h/hash["rx"].rows
=begin        
            
            
            
            int oY=max(max(hash["ul"].rows,hash["ux"].rows),hash["ur"].rows)
            int oB=max(max(hash["dl"].rows,hash["dx"].rows),hash["dr"].rows)
            int oX=max(max(hash["ul"].columns,hash["lx"].columns),hash["dl"].columns)
            int oD=max(max(hash["ur"].columns,hash["rx"].columns),hash["dr"].columns)
            offY=oY+hash["uy"].rows
            int offB=oB+hash["dy"].rows
            offX=oX+hash["ly"].columns
            int offD=oD+hash["ry"].columns
            
            w=offD+offX+w
            h=offY+offB+h
            
            w=min(w-hash["uy"].columns,w-hash["dy"].columns)/2
            h=min(h-hash["ly"].rows,h-hash["ry"].rows)/2
            if(w<0){
                offX-=w
                offD-=w-1
                w=max(hash["uy"].columns,hash["dy"].columns)
            }
            if(h<0){
                offY-=h
                offB-=h-1
                h=max(hash["ly"].rows,hash["ry"].rows)
            }
            
            buff = new BufferedImage(w,h,BufferedImage.TYPE_4BYTE_ABGR)
            Graphics g=buff.getGraphics()
            
            g.drawImage(hash["ul"],offX-hash["ul"].columns,offY-hash["ul"].rows,null)
            for(int i=0,I=offX;i<iTime;i++,I+=hash["ux"].columns)
                g.drawImage(hash["ux"],I,offY-hash["ux"].rows,null)
            g.drawImage(hash["ur"],w-offD,offY-hash["ur"].rows,null)
            for(int i=0,I=offY;i<jTime;i++,I+=hash["lx"].rows)
                g.drawImage(hash["lx"],offX-hash["lx"].columns,I,null)
            for(int i=offX,I=0;I<mTimeX;i+=hash["cx"].columns,I++)
                for(int j=offY,J=0;J<mTimeY;j+=hash["cx"].rows,J++)
                    g.drawImage(hash["cx"],i,j,null)
            for(int i=0,I=offY;i<kTime;i++,I+=hash["rx"].rows)
                g.drawImage(hash["rx"],w-offD,I,null)
            g.drawImage(hash["dl"],offX-hash["dl"].columns,h-offB,null)
            for(int i=0,I=offX;i<lTime;i++,I+=hash["dx"].columns)
                g.drawImage(hash["dx"],I,h-offB,null)
            g.drawImage(hash["dr"],w-offD,h-offB,null)
            g.drawImage(hash["uy"],(w-hash["uy"].columns)/2,offY-hash["uy"].rows-oY,null)
            g.drawImage(hash["ly"],offX-hash["ly"].columns-oX,(h-hash["ly"].rows)/2,null)
            g.drawImage(hash["ry"],w-offD+oD,(h-hash["ry"].rows)/2,null)
            g.drawImage(hash["dy"],(w-hash["dy"].columns)/2,h-offB+oB,null)
            buff.flush()
=end
    Magick::Image.new(1,1,Magick::HatchFill.new('#0000')).first.to_blob
  end
end
