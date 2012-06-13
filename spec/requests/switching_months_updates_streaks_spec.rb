require 'spec_helper'

describe "SwitchingMonthsUpdatesStreaks" do
  describe "GET /'/habits/:id/streak'" do
    it "should update the streak knob when the month changes" do
      visit root_url
      # sign up
      # get redirected to root_url
      # create a habit
      # select the habit
      # create a chain (length 1)
      # streak should now read one
      # change the month
      # within("#streak") do
        # assert has_selector?("#streak"), value: 0
      # end
    end
  end
end
