class ChainsController < ApplicationController

  before_filter :authenticate_user!
  respond_to :json

  # GET /chains
  def index
    if params[:habit_id]
      @chains = Chain.find_all_by_habit_id_and_user_id(params[:habit_id], current_user.id)
      respond_with @chains
    end
  end

  # POST /chains
  def create
    # TODO make sure the habit exists and belongs to the user in question
    @chain = Chain.new(params[:chain])
    @chain.user_id = current_user.id

    if @chain and @chain.day <= Date.today
      if @chain.save
        # check to see if there are any links around the current chain
        link_count = get_link_backward(@chain.user_id, @chain.habit_id, @chain.day, 0)
        link_count = link_count + get_link_forward(@chain.user_id, @chain.habit_id, @chain.day+1, 0)
        respond_with({ :chain => @chain, :link_count => link_count}, :status => :created, :location => @chain)
      else
        respond_with(@chain.errors, :status => :unprocessable_entity)
      end
    else
      respond_with({:error => 'Are you from the future?! You can\'t possibly have done anything on that day yet. Try again.'}, :status => 406, :location => nil)
    end

  end

  # DELETE /chains/1
  def destroy
    @chain = Chain.find(params[:id])
    @chain.destroy

    respond_with nil

  end

  private

    def get_link_backward(user_id, habit_id, day, x)
      chain = Chain.find_by_habit_id_and_user_id_and_day(habit_id, user_id, day)
      if !chain
        return x;
      else
        return get_link_backward(user_id, habit_id, day-1, x+1)
      end
    end

    def get_link_forward(user_id, habit_id, day, x)
      chain = Chain.find_by_habit_id_and_user_id_and_day(habit_id, user_id, day)
      if !chain
        return x;
      else
        return get_link_forward(user_id, habit_id, day+1, x+1)
      end
    end

end