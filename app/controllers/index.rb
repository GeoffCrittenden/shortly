require 'base64'

# ///////////  GET  //////////////////

INVALID_SHURLY_MSG = 'Invalid Shurly, please check again.'.freeze unless defined?(INVALID_SHURLY_MSG)
INVALID_URL_MSG    = 'URL provided is invalid.  Please use '      unless defined?(INVALID_URL_MSG)

get '/' do
  erb :index
end

get '/s/:shortly' do
  if params[:shortly].length >= 6
    @shortly = Shortly.find_by_shortly(params[:shortly])
  else
    @error = INVALID_SHURLY_MSG
  end
  erb :index
end

get '/*' do |shortly|
  @shortly = Shortly.find_by_shortly(shortly) if shortly.length == 6
  if @shortly
    redirect @shortly.url
  else
    @error = INVALID_SHURLY_MSG
    erb :index
  end
end

# ////////////  POST  /////////////////

post '/error' do
  @error = "#{params[:url]} is not a valid URL."
  erb :index
end

post '/shurlyit' do
  if valid_url?
    id = if Shortly.maximum(:id).nil?
           ''
         else
           Shortly.maximum(:id).next.to_s
         end
    short = Shortly.create(url:     params_url,
                           longly:  Base64.encode64(id + url_body),
                           shortly: Base64.encode64(id + url_body)[0..5],
                           lead:    url_lead,
                           body:    url_body)
    redirect "/s/#{short.shortly}"
  else
    redirect '/error', 307
  end
end
