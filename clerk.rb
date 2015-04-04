require 'sinatra/base'
require "sinatra/activerecord"

class ClerkApp < Sinatra::Base
  
  enable :sessions
  enable :logging
  set :root, './public/root'
  set :views, './views'
  set :public_folder, './public'
  
  helpers do
    def h(text)
      Rack::Utils.escape_html(text)
    end
    
    def size_of(file)
      return '' if File.directory? file
      size = File.size(file).to_f
      case size
      when 0..1023
        "#{size.to_i} bytes"
      when 1024..1048575
        "#{(size / 1024.0).round(2)} kb"
      when 1048576..1073741823
        "#{(size / 1024.0 / 1024.0).round(2)} mb"
      when 1073741824..Float::INFINITY
        "#{(size / 1024.0 / 1024.0 / 1024.0).round(2)} gb"
      else
        ""
      end
    end
    
  end
  
  Dir['models/*.rb'].each { |m| load m }
  
  get '*' do |directory|
    @directory = directory
    @path = File.join(settings.root, @directory)
    not_found unless File.exist? @path
    
    if File.directory?(@path)
      if params[:json]
        {
          @directory => Dir[File.join(@path, "*")].collect do |f|
            {
              name: File.basename(f),
              kind: File.directory?(f) ? 'folder' : 'file',
              size: size_of(f)
            }
          end
        }.to_json
      else
        erb :index
      end
    else
      send_file @path
    end
  end
  
  # get // do
  #   erb request.path_info.to_sym rescue pass
  # end
  
  not_found do
    erb :error_404
  end
  
  error do
    erb :error
  end
  
end
