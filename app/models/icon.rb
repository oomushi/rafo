class Icon < ActiveRecord::Base
  validates_presence_of :user_id
  belongs_to :user
  belongs_to :blob
  validate :right_size?
  validates_presence_of :blob_id
  
  def uploaded_data= image
    self.build_blob({
      :file=>image.read,
      :content_type=>image.content_type.chomp })
  end
  
  def self.random
    if (c = count) != 0
      find(:first, :offset =>rand(c))
    end
  end
  
  protected
  def right_size?
    unless self.blob.file.nil?
      begin
        image=MiniMagick::Image.read self.blob.file
        size=image.size
        errors.add(:uploaded_data, "width to high") if size.width > 128 # parametro da prendere da qualche altra parte
        errors.add(:uploaded_data, "hight to high") if size.height > 128 # parametro da prendere da qualche altra parte
        errors.add(:uploaded_data, "invalid image type") unless ['image/png','image/gif','image/jpeg'].include? image.mime_type # parametro da prendere da qualche altra parte
      rescue => e
        errors.add(:uploaded_data, "invalid file type"+e.to_s)
      end
    end
  end
end
