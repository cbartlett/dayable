class ChainsController < ApplicationController

  before_filter :authenticate_user!, :except => [:create, :destroy]
  respond_to :json

  # GET /chains
  def index
    if params[:habit_id]
      @chains = Chain.find_all_by_habit_id_and_user_id(params[:habit_id], current_or_guest_user.id)
      respond_with @chains
    end
  end

  # POST /chains
  def create
    # TODO make sure the habit exists and belongs to the user in question
    @chain = Chain.new(params[:chain])
    @chain.user_id = current_or_guest_user.id

    habit = Habit.find(@chain.habit_id)

    if @chain and @chain.day <= Date.today
      if @chain.save
        # check to see if there are any links around the current chain
        link_count = habit.get_link_count_starting_with_chain(@chain)

        # generate the appropriate link message
        link_message = habit.get_link_message

        respond_with({ :chain => @chain, :link_count => link_count, :link_message => link_message}, :status => :created, :location => @chain)
      else
        respond_with(@chain.errors, :status => :unprocessable_entity)
      end
    else
      respond_with({:error => t(:future_error)}, :status => 406, :location => nil)
    end

  end

  # DELETE /chains/1
  def destroy
    @chain = Chain.find(params[:id])
    @chain.destroy

    respond_with nil

  end

  private

end