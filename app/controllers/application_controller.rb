class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from ActiveRecord::RecordNotUnique, :with => :nothing

  protected
    def nothing
      
    end
end
