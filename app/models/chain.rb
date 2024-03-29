class Chain < ActiveRecord::Base

  validates_presence_of :user_id
  validates_presence_of :habit_id
  validates_presence_of :day

  attr_accessible :day, :user_id, :habit_id

  belongs_to :user
  belongs_to :habit

end
