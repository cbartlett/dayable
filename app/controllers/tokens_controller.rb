class TokensController < ApplicationController

  respond_to :json

  def create
    @user = User.find_record(params[:login])

    if @user and @user.valid_password?(params[:password])
      @user.reset_authentication_token!
      respond_with({:auth_token => @user.authentication_token}, :status => 200, :location => nil)
    else
      respond_with({:error => 'Incorrect username or password'}, :status => 401, :location => nil)
    end
  end

  def destroy
    @user = User.find_by_authentication_token(params[:auth_token])
    if @user
      @user.authentication_token = nil
      @user.save
      respond_with({ :token => params[:token] }, :status => 200)
    end
  end

end