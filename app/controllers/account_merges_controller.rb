class AccountMergesController < ApplicationController

  def create
    @user = find_user

    if @user
      load_email_from_session
      @user.save!
      remove_email_from_session
      self.current_user = @user
      redirect_back_or_to root_url, notice: 'Welcome!'
    else
      redirect_to transition_session_path,
                  alert: 'Sorry, no account found. Try a different provider.'
    end
  end

  private

  def find_user
    provider = omniauth['provider']
    uid = omniauth['uid']
    User.where(provider: provider, uid: uid).first
  end

  def omniauth
    request.env['omniauth.auth']
  end

  def load_email_from_session
    @user.email = session[:new_user_email] if session[:new_user_email]
  end

  def remove_email_from_session
    session.delete(:new_user_email)
  end

end
