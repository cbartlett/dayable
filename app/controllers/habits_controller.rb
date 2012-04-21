class HabitsController < ApplicationController

  before_filter :authenticate_user!, :except => [:index]

  respond_to :json, :html

  # GET /habits
  # GET /habits.json
  def index
    @habits = Habit.all

    respond_with @habits
  end

  def show
    @habit = Habit.find(params[:id])
    respond_with @habit
  end

  # POST /habits
  # POST /habits.json
  def create
    @habit = Habit.new(params[:habit])
    @habit.user_id = current_user.id

    if @habit.save
      respond_with @habit, status: :created
    else
      respond_with @habit.errors, status: :unprocessable_entity
    end

  end

  # PUT /habits/1
  # PUT /habits/1.json
  def update
    @habit = Habit.find(params[:id])

    if @habit.update_attributes(params[:habit])
      respond_with @habit
    else
      respond_with @habit.errors, status: :unprocessable_entity
    end
  end

  # DELETE /habits/1
  # DELETE /habits/1.json
  def destroy
    @habit = Habit.find(params[:id])
    @habit.destroy

    respond_with @habit
  end
end
