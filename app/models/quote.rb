class Quote < ActiveRecord::Base
  belongs_to :user
  def self.random
    if (c = count) != 0
      find(:first, :offset =>rand(c))
    end
  end
  def transform request
    self.text.sub('~h',request.remote_ip).sub('~b',request.env['HTTP_USER_AGENT'] )
  end
end
