class Habit < ActiveRecord::Base

  belongs_to :user
  has_many :chains, :dependent => :destroy, :order => "day ASC"
  has_many :users, :through => :chains

  validates :content, :presence => true, :length => { :in =>  3..20 }

  attr_accessible :content

  def get_highest_link_count
    highest_link_count = 0
    self.chains.each do |c|
      link_count = get_link_count_backward(c.user_id, c.habit_id, c.day, 0)  
      link_count = get_link_count_forward(c.user_id, c.habit_id, c.day+1, link_count)

      if(link_count > highest_link_count)
        highest_link_count = link_count
      end
    end
    return highest_link_count
  end

  def get_highest_link_count_by_current_month
    highest_link_count = 0
    start_date = Time.now.beginning_of_month
    end_date = Time.now.end_of_month
    self.chains.where("day >= :start_date AND day < :end_date", { :start_date => start_date, :end_date => end_date }).each do |c|
      link_count = get_link_count_backward(c.user_id, c.habit_id, c.day, 0)
      link_count = get_link_count_forward(c.user_id, c.habit_id, c.day+1, link_count)

      if(link_count > highest_link_count)
        highest_link_count = link_count
      end
    end
    return highest_link_count
  end

  def get_link_count_starting_with_chain(chain)
    link_count = get_link_count_backward(chain.user_id, chain.habit_id, chain.day, 0)
    link_count = link_count + get_link_count_forward(chain.user_id, chain.habit_id, chain.day+1, 0)
    return link_count
  end

  private

    def get_link_count_backward(user_id, habit_id, day, x)
      chain = Chain.find_by_user_id_and_habit_id_and_day(user_id, habit_id, day)
      if !chain
        return x;
      else
        return get_link_count_backward(user_id, habit_id, day-1, x+1)
      end
    end

    def get_link_count_forward(user_id, habit_id, day, x)
      chain = Chain.find_by_user_id_and_habit_id_and_day(user_id, habit_id, day)
      if !chain
        return x;
      else
        return get_link_count_forward(user_id, habit_id, day+1, x+1)
      end
    end

end
