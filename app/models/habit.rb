class Habit < ActiveRecord::Base

  belongs_to :user

  validates :content, :presence => true
  validates :color, :presence => true
  validates_inclusion_of :color, :in => 0..16777215

  attr_accessible :content, :color, :user_id
end
