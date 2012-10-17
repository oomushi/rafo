class Image < ActiveRecord::Base
  belongs_to :user
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