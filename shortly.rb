class Shortly

  attr_reader :shortly, :longly

  def initialize(url)
    puts self.object_id
    @shortly = "http://short.ly/#{self.object_id.to_s(36)}"
    @longly  = url

  end

end

url = "http://www.citypulse.io"
short = Shortly.new(url)
puts short.shortly
puts short.longly