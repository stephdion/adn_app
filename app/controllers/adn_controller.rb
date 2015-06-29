class AdnController < ApplicationController
  
  def do_login
    password = params['login']['password']
    username = params['login']['user']

    cookies[:user_name] = username 
    cookies[:sessionid] = username

    # Set a simple session cookie
    # Set a cookie that expires in 1 hour
    # cookies[:login] = { :value => "XJ12", :expires => Time.now + 3600}
    
    redirect_to '/dashboard'
  end
end
