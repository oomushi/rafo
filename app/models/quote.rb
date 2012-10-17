class Quote < ActiveRecord::Base
  belongs_to :user
  def self.random
    if (c = count) != 0
      find(:first, :offset =>rand(c))
    end
  end
end
