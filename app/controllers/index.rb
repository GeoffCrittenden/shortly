require 'base64'

# ///////////  GET  //////////////////

INVALID_SHURLY_MSG = 'Invalid Shurly, please check again.'.freeze

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

post '/shurlyit' do
  matcher = /(\Ahttps?:\/\/www\.|\Ahttps?:\/\/)(.+)/
  if matcher.match(params[:url])
    lead = matcher.match(params[:url])[1]
    body = matcher.match(params[:url])[2]
  else
    lead = 'http://'
    body = params[:url]
  end
  id = if Shortly.maximum(:id).nil?
         ''
       else
         Shortly.maximum(:id).next.to_s
       end
  short = Shortly.create(url:     lead + body,
                         longly:  Base64.encode64(id + body),
                         shortly: Base64.encode64(id + body)[0..5],
                         lead:    lead,
                         body:    body)
  redirect "/s/#{short.shortly}"
end
