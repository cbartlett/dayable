class Habit < ActiveRecord::Base
  attr_accessible :content, :color, :user_id
end
