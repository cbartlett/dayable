class ChainsController < ApplicationController

  before_filter :authenticate_user!, :except => [:index]
  respond_to :json

  # GET /chains
  def index
    if params[:day]
      # try to parse the date
      day = DateTime.parse(params[:day])
      @chains = Chain.find_all_by_day(day, :include => [:habit])
      respond_with(@chains, :include => :habit)
    else
      @chains = Chain.all
      respond_with(@chains)
    end
    
  end

  # POST /chains
  def create
    @chain = Chain.new(params[:chain])
    @chain.user_id = current_user.id

    if @chain.save
      # TODO: Return the number of links in the chain in this message (select count(*) from chains where user_id = '1' and habit_id = '1')
      respond_with(@chain, :status => :created, :location => @chain)
    else
      respond_with(@chain.errors, :status => :unprocessable_entity)
    end

  end

end