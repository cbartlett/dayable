class ChainsController < ApplicationController

  before_filter :authenticate_user!
  respond_to :json

  # GET /chains
  def index
    if params[:day]
      # try to parse the date
      day = Date.parse(params[:day])
      @chains = Chain.find_all_by_day_and_user_id(day, current_user.id, :include => [:habit])
      respond_with(@chains, :include => :habit)
    else
      @chains = Chain.find_all_by_user_id(current_user.id)
      respond_with(@chains)
    end
    
  end

  # POST /chains
  def create
    @chain = Chain.new(params[:chain])
    @chain.user_id = current_user.id

    if @chain.save
      # TODO: Return the number of links in the chain in this message (select count(*) from chains where user_id = '1' and habit_id = '1')
      # number of links = consecutive days this habit has been completed
      respond_with({:chain => @chain, :habit => @chain.habit}, :status => :created, :location => @chain)
    else
      respond_with(@chain.errors, :status => :unprocessable_entity)
    end

  end

  # DELETE /chains/1
  def destroy
    @chain = Chain.find(params[:id])
    @chain.destroy

    respond_with @chain

  end

end