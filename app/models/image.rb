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

###a
##eif
#cjmkb
##glh
###d
=begin
       uy
   ul ux ur
ly lx cx rx ry
   dl dx dr
      dy 
=end
  def to_img
=begin
            int  w    = 0,h= 0;
            int mTimeX=0,mTimeY = 0,iTime=0,jTime=0,kTime=0,lTime=0;
            int column,c1,c2,c3,row,row1,row2,row3;
            DocumentBuilderFactory dbf=DocumentBuilderFactory.newInstance();
            dbf.setIgnoringElementContentWhitespace(true);
            dbf.setIgnoringComments(true);
            DocumentBuilder db = dbf.newDocumentBuilder();
            d = db.parse(file);
            NodeList n = d.getDocumentElement().getChildNodes();
            String path=file.getAbsolutePath().substring(0,file.getAbsolutePath().lastIndexOf(java.io.File.separatorChar));
            for (int i = 0; i < n.getLength(); i++)
                if(n.item(i).getNodeType()==Node.ELEMENT_NODE)
                    hash.put(n.item(i).getAttributes().item(1).getNodeValue(),ImageIO.read(ImageIO.createImageInputStream(new File(path+"/"+n.item(i).getAttributes().item(0).getNodeValue()))));
            
            BufferedImage nill=new BufferedImage(1,1,BufferedImage.TYPE_4BYTE_ABGR);
            for(int i=0,j=97;i<13;i++,j++)
               if(!hash.containsKey(""+(char)j))
                    hash.put(""+(char)j,nill);
            
            mTimeX=(int)Math.ceil(1.0*l/hash.get("m").getWidth());
            mTimeY=(int)Math.ceil(1.0*a/hash.get("m").getHeight());
            
            int W= mTimeX*hash.get("m").getWidth().lcm hash.get("l").getWidth().lcm hash.get("i").getWidth()
            int H= mTimeY*hash.get("m").getHeight().lcm hash.get("j").getHeight().lcm hash.get("k").getHeight()
            
            mTimeX=(int)W/hash.get("m").getWidth();
            mTimeY=(int)H/hash.get("m").getHeight();
            iTime=(int)W/hash.get("i").getWidth();
            lTime=(int)W/hash.get("l").getWidth();
            jTime=(int)H/hash.get("j").getHeight();
            kTime=(int)H/hash.get("k").getHeight();
            int oY=max(max(hash.get("e").getHeight(),hash.get("i").getHeight()),hash.get("f").getHeight());
            int oB=max(max(hash.get("g").getHeight(),hash.get("l").getHeight()),hash.get("h").getHeight());
            int oX=max(max(hash.get("e").getWidth(),hash.get("j").getWidth()),hash.get("g").getWidth());
            int oD=max(max(hash.get("f").getWidth(),hash.get("k").getWidth()),hash.get("h").getWidth());
            offY=oY+hash.get("a").getHeight();
            int offB=oB+hash.get("d").getHeight();
            offX=oX+hash.get("c").getWidth();
            int offD=oD+hash.get("b").getWidth();
            
            w=offD+offX+W;
            h=offY+offB+H;
            
            W=min(w-hash.get("a").getWidth(),w-hash.get("d").getWidth())/2;
            H=min(h-hash.get("c").getHeight(),h-hash.get("b").getHeight())/2;
            if(W<0){
                offX-=W;
                offD-=W-1;
                w=max(hash.get("a").getWidth(),hash.get("d").getWidth());
            }
            if(H<0){
                offY-=H;
                offB-=H-1;
                h=max(hash.get("c").getHeight(),hash.get("b").getHeight());
            }
            
            buff = new BufferedImage(w,h,BufferedImage.TYPE_4BYTE_ABGR);
            Graphics g=buff.getGraphics();
            
            g.drawImage(hash.get("e"),offX-hash.get("e").getWidth(),offY-hash.get("e").getHeight(),null);
            for(int i=0,I=offX;i<iTime;i++,I+=hash.get("i").getWidth())
                g.drawImage(hash.get("i"),I,offY-hash.get("i").getHeight(),null);
            g.drawImage(hash.get("f"),w-offD,offY-hash.get("f").getHeight(),null);
            for(int i=0,I=offY;i<jTime;i++,I+=hash.get("j").getHeight())
                g.drawImage(hash.get("j"),offX-hash.get("j").getWidth(),I,null);
            for(int i=offX,I=0;I<mTimeX;i+=hash.get("m").getWidth(),I++)
                for(int j=offY,J=0;J<mTimeY;j+=hash.get("m").getHeight(),J++)
                    g.drawImage(hash.get("m"),i,j,null);
            for(int i=0,I=offY;i<kTime;i++,I+=hash.get("k").getHeight())
                g.drawImage(hash.get("k"),w-offD,I,null);
            g.drawImage(hash.get("g"),offX-hash.get("g").getWidth(),h-offB,null);
            for(int i=0,I=offX;i<lTime;i++,I+=hash.get("l").getWidth())
                g.drawImage(hash.get("l"),I,h-offB,null);
            g.drawImage(hash.get("h"),w-offD,h-offB,null);
            g.drawImage(hash.get("a"),(w-hash.get("a").getWidth())/2,offY-hash.get("a").getHeight()-oY,null);
            g.drawImage(hash.get("c"),offX-hash.get("c").getWidth()-oX,(h-hash.get("c").getHeight())/2,null);
            g.drawImage(hash.get("b"),w-offD+oD,(h-hash.get("b").getHeight())/2,null);
            g.drawImage(hash.get("d"),(w-hash.get("d").getWidth())/2,h-offB+oB,null);
            buff.flush();
        } catch (IOException ioe) {
            ioe.printStackTrace();
        } catch (ParserConfigurationException ex) {
            ex.printStackTrace();
        } catch (SAXException ex) {
            ex.printStackTrace();
        }
=end
  end
end
