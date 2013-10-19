class SessionsController < ApplicationController

  def new; end

  def create
    user = find_user

    if user
      self.current_user = user
      redirect_back_or_to root_url, :notice => "Logged in!"
    else
      store_email_in_session
      redirect_to transition_session_path
    end
  end

  def transition
    @user = User.new
    @user.email = session[:new_user_email]
  end

  def destroy
    self.current_user = nil
    redirect_to root_url, :notice => "Logged out!"
  end

  def failure
    redirect_to root_url, :alert => "Authentication failed. Maybe try again?"
  end

  private

  def store_email_in_session
    session[:new_user_email] = omniauth['info']['email']
  end

  def find_user
    email = omniauth['info']['email']
    User.where(email: email).first
  end

  def omniauth
    request.env['omniauth.auth']
  end

end
