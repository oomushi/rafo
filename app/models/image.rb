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
=begin
 try
    {
      int w = 0;
      int h = 0;
      int mTimeX = 0;
      int mTimeY = 0;
      int iTime = 0;
      int jTime = 0;
      int kTime = 0;
      int lTime = 0;
      org.macrobug.afo.bean.Image img = new Image(id);
      for(char i = 'a'; i <= 'm'; i++)
      {
        if(img.getImgbyChar(i).length() > 0)
        {
          hash.put((new StringBuilder()).append("").append(i).toString(), javax.imageio.ImageIO.read(javax.imageio.ImageIO.createImageInputStream(new File((new StringBuilder()).append(path).append("/").append(img.getImgbyChar(i)).toString()))));
        }
      }

      java.awt.image.BufferedImage nill = new BufferedImage(1, 1, 6);
      int i = 0;
      for(int j = 97; i < 13; j++)
      {
        if(!hash.containsKey((new StringBuilder()).append("").append((char)j).toString()))
        {
          hash.put((new StringBuilder()).append("").append((char)j).toString(), nill);
        }
        i++;
      }

      mTimeX = (int)java.lang.Math.ceil((1.0D * (double)l) / (double)((java.awt.image.BufferedImage)hash.get("m")).getWidth());
      mTimeY = (int)java.lang.Math.ceil((1.0D * (double)a) / (double)((java.awt.image.BufferedImage)hash.get("m")).getHeight());
      int c = mcm(((java.awt.image.BufferedImage)hash.get("m")).getWidth(), mcm(((java.awt.image.BufferedImage)hash.get("l")).getWidth(), ((java.awt.image.BufferedImage)hash.get("i")).getWidth()));
      int W = (int)((double)c * java.lang.Math.ceil((1.0D * (double)mTimeX * (double)((java.awt.image.BufferedImage)hash.get("m")).getWidth()) / (double)c));
      c = mcm(((java.awt.image.BufferedImage)hash.get("m")).getHeight(), mcm(((java.awt.image.BufferedImage)hash.get("j")).getHeight(), ((java.awt.image.BufferedImage)hash.get("k")).getHeight()));
      int H = (int)((double)c * java.lang.Math.ceil((1.0D * (double)mTimeY * (double)((java.awt.image.BufferedImage)hash.get("m")).getHeight()) / (double)c));
      mTimeX = W / ((java.awt.image.BufferedImage)hash.get("m")).getWidth();
      mTimeY = H / ((java.awt.image.BufferedImage)hash.get("m")).getHeight();
      iTime = W / ((java.awt.image.BufferedImage)hash.get("i")).getWidth();
      lTime = W / ((java.awt.image.BufferedImage)hash.get("l")).getWidth();
      jTime = H / ((java.awt.image.BufferedImage)hash.get("j")).getHeight();
      kTime = H / ((java.awt.image.BufferedImage)hash.get("k")).getHeight();
      int oY = java.lang.Math.max(java.lang.Math.max(((java.awt.image.BufferedImage)hash.get("e")).getHeight(), ((java.awt.image.BufferedImage)hash.get("i")).getHeight()), ((java.awt.image.BufferedImage)hash.get("f")).getHeight());
      int oB = java.lang.Math.max(java.lang.Math.max(((java.awt.image.BufferedImage)hash.get("g")).getHeight(), ((java.awt.image.BufferedImage)hash.get("l")).getHeight()), ((java.awt.image.BufferedImage)hash.get("h")).getHeight());
      int oX = java.lang.Math.max(java.lang.Math.max(((java.awt.image.BufferedImage)hash.get("e")).getWidth(), ((java.awt.image.BufferedImage)hash.get("j")).getWidth()), ((java.awt.image.BufferedImage)hash.get("g")).getWidth());
      int oD = java.lang.Math.max(java.lang.Math.max(((java.awt.image.BufferedImage)hash.get("f")).getWidth(), ((java.awt.image.BufferedImage)hash.get("k")).getWidth()), ((java.awt.image.BufferedImage)hash.get("h")).getWidth());
      offY = oY + ((java.awt.image.BufferedImage)hash.get("a")).getHeight();
      int offB = oB + ((java.awt.image.BufferedImage)hash.get("d")).getHeight();
      offX = oX + ((java.awt.image.BufferedImage)hash.get("c")).getWidth();
      int offD = oD + ((java.awt.image.BufferedImage)hash.get("b")).getWidth();
      w = offD + offX + W;
      h = offY + offB + H;
      W = java.lang.Math.min(w - ((java.awt.image.BufferedImage)hash.get("a")).getWidth(), w - ((java.awt.image.BufferedImage)hash.get("d")).getWidth()) / 2;
      H = java.lang.Math.min(h - ((java.awt.image.BufferedImage)hash.get("c")).getHeight(), h - ((java.awt.image.BufferedImage)hash.get("b")).getHeight()) / 2;
      if(W < 0)
      {
        offX -= W;
        offD -= W - 1;
        w = java.lang.Math.max(((java.awt.image.BufferedImage)hash.get("a")).getWidth(), ((java.awt.image.BufferedImage)hash.get("d")).getWidth());
      }
      if(H < 0)
      {
        offY -= H;
        offB -= H - 1;
        h = java.lang.Math.max(((java.awt.image.BufferedImage)hash.get("c")).getHeight(), ((java.awt.image.BufferedImage)hash.get("b")).getHeight());
      }
      buff = new BufferedImage(w, h, 6);
      java.awt.Graphics g = buff.getGraphics();
      g.drawImage((java.awt.Image)hash.get("e"), offX - ((java.awt.image.BufferedImage)hash.get("e")).getWidth(), offY - ((java.awt.image.BufferedImage)hash.get("e")).getHeight(), null);
      i = 0;
      for(int I = offX; i < iTime; I += ((java.awt.image.BufferedImage)hash.get("i")).getWidth())
      {
        g.drawImage((java.awt.Image)hash.get("i"), I, offY - ((java.awt.image.BufferedImage)hash.get("i")).getHeight(), null);
        i++;
      }

      g.drawImage((java.awt.Image)hash.get("f"), w - offD, offY - ((java.awt.image.BufferedImage)hash.get("f")).getHeight(), null);
      i = 0;
      for(int I = offY; i < jTime; I += ((java.awt.image.BufferedImage)hash.get("j")).getHeight())
      {
        g.drawImage((java.awt.Image)hash.get("j"), offX - ((java.awt.image.BufferedImage)hash.get("j")).getWidth(), I, null);
        i++;
      }

      i = offX;
      for(int I = 0; I < mTimeX; I++)
      {
        int j = offY;
        for(int J = 0; J < mTimeY; J++)
        {
          g.drawImage((java.awt.Image)hash.get("m"), i, j, null);
          j += ((java.awt.image.BufferedImage)hash.get("m")).getHeight();
        }

        i += ((java.awt.image.BufferedImage)hash.get("m")).getWidth();
      }

      i = 0;
      for(int I = offY; i < kTime; I += ((java.awt.image.BufferedImage)hash.get("k")).getHeight())
      {
        g.drawImage((java.awt.Image)hash.get("k"), w - offD, I, null);
        i++;
      }

      g.drawImage((java.awt.Image)hash.get("g"), offX - ((java.awt.image.BufferedImage)hash.get("g")).getWidth(), h - offB, null);
      i = 0;
      for(int I = offX; i < lTime; I += ((java.awt.image.BufferedImage)hash.get("l")).getWidth())
      {
        g.drawImage((java.awt.Image)hash.get("l"), I, h - offB, null);
        i++;
      }

      g.drawImage((java.awt.Image)hash.get("h"), w - offD, h - offB, null);
      g.drawImage((java.awt.Image)hash.get("a"), (w - ((java.awt.image.BufferedImage)hash.get("a")).getWidth()) / 2, offY - ((java.awt.image.BufferedImage)hash.get("a")).getHeight() - oY, null);
      g.drawImage((java.awt.Image)hash.get("c"), offX - ((java.awt.image.BufferedImage)hash.get("c")).getWidth() - oX, (h - ((java.awt.image.BufferedImage)hash.get("c")).getHeight()) / 2, null);
      g.drawImage((java.awt.Image)hash.get("b"), (w - offD) + oD, (h - ((java.awt.image.BufferedImage)hash.get("b")).getHeight()) / 2, null);
      g.drawImage((java.awt.Image)hash.get("d"), (w - ((java.awt.image.BufferedImage)hash.get("d")).getWidth()) / 2, (h - offB) + oB, null);
      buff.flush();
    }
    catch(java.io.IOException ioe)
    {
      ioe.printStackTrace();
    } 
=end
  end
end
=begin
       uy
   ul ux ur
ly lx cx rx ry
   dl dx dr
      dy 
  a
 eif
bjmkc
 glh
  d
=end