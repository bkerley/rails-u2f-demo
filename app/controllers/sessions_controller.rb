class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.
      find_by(username: params[:username]).
      try(:authenticate, params[:password])

    if @user
      redirect_to root_path
    else
      redirect_to action: 'new'
    end
  end
end
