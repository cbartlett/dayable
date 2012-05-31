require 'test_helper'

class HabitTest < ActiveSupport::TestCase
  test "invalid without content" do
    h = Habit.new
    assert !h.valid?, 'Habit was not valid'
  end
end
