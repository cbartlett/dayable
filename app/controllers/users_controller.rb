class UsersController < ApplicationController

  respond_to :json

  def create
    @user = User.new(params[:user])

    if @user.save
      respond_with(@user, :status => 200, :location => nil)
    else
      respond_with({:error => "Could not create user"}, :status => :unprocessable_entity, :location => nil )
    end

  end

  def destroy
    @user = User.find(params[:id])

    if @user and @user.valid_password?(params[:password])
      respond_with(:status => 200, :location => nil)
    else
      respond_with({:error => "Incorrect password." }, :status => 401, :location => nil)
    end
  end

end