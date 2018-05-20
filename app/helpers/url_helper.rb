# module UrlHelper
def params_url
  @uri = URI.parse(params[:url])
  url_lead + url_body
end

def url_lead
  "#{@uri.scheme}://"
end

def url_body
  "#{@uri.host}#{@uri.path}#{@uri.query.present? ? '?' + @uri.query : ''}"
end
