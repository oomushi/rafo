class Icon < ActiveRecord::Base
  validates_presence_of :user_id
  belongs_to :user
  belongs_to :blob
  validate :right_size?
  
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
        image=Magick::Image.read_inline(Base64.encode64 self.blob.file).first
        errors.add(:uploaded_data, "width to high") if image.columns > 128 # TODO parametro da prendere da qualche altra parte
        errors.add(:uploaded_data, "hight to high") if image.rows > 128    # TODO parametro da prendere da qualche altra parte
        errors.add(:uploaded_data, "invalid image type") unless ['image/png','image/gif','image/jpeg'].include? image.mime_type # parametro da prendere da qualche altra parte
      rescue
        errors.add(:uploaded_data, "invalid file type")
      end
    end
  end
end
