class UsersController < ApplicationController

  PER_PAGE = 15

  before_filter :ensure_authenticated!, :only => [:edit, :update]

  def new
    @user = User.new
    load_sensitive_user_data_from_session
  end

  def show
    @user = User.find_by_nickname!(params[:nickname]).decorate

    collection = @user.asciicasts.
      includes(:user).
      order("created_at DESC").
      page(params[:page]).
      per(PER_PAGE)

    @asciicasts = PaginatingDecorator.new(collection)
  end

  def create
    @user = User.new(params[:user])
    load_sensitive_user_data_from_session

    if @user.save
      clear_sensitive_session_user_data
      self.current_user = @user
      redirect_back_or_to root_url, :notice => "Welcome!"
    else
      render 'users/new', :status => 422
    end
  end

  def edit
    @user = current_user
  end

  def update
    current_user.update_attributes(params[:user])
    redirect_to profile_path(current_user),
                :notice => 'Account settings saved.'
  end

  private

  def load_sensitive_user_data_from_session
    @user.email = session[:new_user_email] if session[:new_user_email]
  end

  def clear_sensitive_session_user_data
    session.delete(:new_user_email)
  end

end
