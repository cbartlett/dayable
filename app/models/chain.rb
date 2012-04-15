class Chain < ActiveRecord::Base

  validates_presence_of :user_id
  validates_presence_of :habit_id
  validates_presence_of :day

  attr_accessible :user_id, :habit_id, :day

  belongs_to :user
  belongs_to :habit
end
