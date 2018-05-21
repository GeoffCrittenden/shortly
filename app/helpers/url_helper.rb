# module UrlHelper
def valid_url?
  @uri = URI.parse(params[:url])
  @uri.kind_of?(URI::HTTP) || @uri.host.present? || @uri.path =~ /.+\..+/
end

def params_url
  url_lead + url_body
end

def url_lead
  "#{@uri.scheme || 'http'}://"
end

def url_body
  "#{@uri.host}#{@uri.path}#{@uri.query.present? ? '?' + @uri.query : ''}"
end
