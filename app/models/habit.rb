class Habit < ActiveRecord::Base

  belongs_to :user
  has_many :chains, :dependent => :destroy
  has_many :users, :through => :chains

  validates :content, :presence => true

  attr_accessible :content
end
