require 'base64'

# ///////////  GET  //////////////////

get '/' do
  # Look in app/views/index.erb
  erb :index
end

get '/:id' do
  if params[:id].length >= 8
    @shortly = Shortly.find_by_shortly(params[:id])
    if @shortly
      redirect "#{@shortly.lead}#{@shortly.body}"
    else
      @error = "Invalid Shortly, please check again."
    end
  else
    @error = "Invalid Shortly, please check again."
  end
  erb :index
end

get '/shortly/:id' do
  if params[:id].length >= 6
    @shortly = Shortly.find_by_shortly(params[:id])
  else
    @error = "Invalid Shortly, please check again."
  end
  erb :index
end

# ////////////  POST  /////////////////

post '/shorten' do
  if /(\Ahttps?:\/\/www\.|\Ahttps?:\/\/)(.+)/.match(params[:url])
    lead = /(\Ahttps?:\/\/www\.|\Ahttps?:\/\/)(.+)/.match(params[:url])[1]
    body = /(\Ahttps?:\/\/www\.|\Ahttps?:\/\/)(.+)/.match(params[:url])[2]
  else
    lead = "http://"
    body = params[:url]
  end
  short = Shortly.create( url:     params[:url],
                          longly:  Base64.encode64(body),
                          shortly: Base64.encode64(body)[0..5],
                          lead:    lead,
                          body:    body )
  redirect "/shortly/#{short.shortly}"
end