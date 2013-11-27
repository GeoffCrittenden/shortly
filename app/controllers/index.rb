require 'base64'

# ///////////  GET  //////////////////

get '/' do
  # Look in app/views/index.erb
  erb :index
end

get '/:id' do
  erb :index
end

# ////////////  POST  /////////////////

post '/shorten' do
  if /(\Ahttp:\/\/www\.|\Ahttps:\/\/www\.|\Ahttp:\/\/|\Ahttps:\/\/)(.+)/.match(params[:url])
    lead = /(\Ahttp:\/\/www\.|\Ahttps:\/\/www\.|\Ahttp:\/\/|\Ahttps:\/\/)(.+)/.match(params[:url])[1]
    body = /(\Ahttp:\/\/www\.|\Ahttps:\/\/www\.|\Ahttp:\/\/|\Ahttps:\/\/)(.+)/.match(params[:url])[2]
  else
    lead = "http://"
    body = params[:url]
  end
  short = Shortly.create( url:     params[:url],
                          longly:  Base64.encode64(body),
                          shortly: Base64.encode64(body)[0..7],
                          lead:    lead,
                          body:    body )
  redirect "/#{short.shortly}"
end