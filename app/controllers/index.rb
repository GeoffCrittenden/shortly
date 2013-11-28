require 'base64'

# ///////////  GET  //////////////////

get '/' do
  # Look in app/views/index.erb
  erb :index
end

get '/:shortly' do
  if params[:shortly].length == 6
    @shortly = Shortly.find_by_shortly(params[:shortly])
    if @shortly
      redirect "#{@shortly.lead}#{@shortly.body}"
    else
      @error = "Invalid Shurly, please check again."
    end
  else
    @error = "Invalid Shurly, please check again."
  end
  erb :index
end

get '/s/:shortly' do
  if params[:shortly].length >= 6
    @shortly = Shortly.find_by_shortly(params[:shortly])
  else
    @error = "Invalid Shurly, please check again."
  end
  erb :index
end

# ////////////  POST  /////////////////

post '/shurlyit' do
  if /(\Ahttps?:\/\/www\.|\Ahttps?:\/\/)(.+)/.match(params[:url])
    lead = /(\Ahttps?:\/\/www\.|\Ahttps?:\/\/)(.+)/.match(params[:url])[1]
    body = /(\Ahttps?:\/\/www\.|\Ahttps?:\/\/)(.+)/.match(params[:url])[2]
  else
    lead = "http://"
    body = params[:url]
  end
  if Shortly.maximum(:id) == nil
    id = ''
  else
    id = Shortly.maximum(:id).next.to_s
  end 
  short = Shortly.create( url:     params[:url],
                          longly:  Base64.encode64(id + body),
                          shortly: Base64.encode64(id + body)[0..5],
                          lead:    lead,
                          body:    body )
  redirect "/s/#{short.shortly}"
end