class Shortly

  def initialize(url)
    url.to_i(36)
    
  end

end

url = "http://www.citypulse.io"
short = Shortly.new(url)