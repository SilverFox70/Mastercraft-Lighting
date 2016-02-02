class ProductionsController < ApplicationController
  before_action :set_production, only: [:show, :update, :destroy]

  def index
    p params
    authenticate_user!
    set_productions
    render :index
  end

  def create
    p "*" * 40
    p params.inspect
    set_productions
    @production = Production.new(name: params[:production][:name], date: params[:production][:date], designer_id: current_user.id)
    if @production.save
      render :index
    else
      redirect_to :root
    end

  end

  def new
    @production = Production.new(designer_id: current_user.id)
    render '_new_form', layout: false
  end

  def edit

  end

  # Change the logic here so that if equipment records lack channel info this will still order the data in a sensible way
  def show
    @equipment = @production.equipments.sort_by &:channel
    render :show
  end

  def update

  end

  def destroy
    production = Production.find(params[:id])
    production.destroy
    redirect_to productions_path
  end


  def print
    p params
  	@production = Production.find(params[:id])
  	@equipment = @production.equipments.sort_by &:channel
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "print_views", :template => "print.html.erb"
      end
    end
  end


  private

   def set_production
    if params[:id]
      @production = Production.find(params[:id])
  	else
  		@production = Production.find(params[:production_id])
  	end
   end
    def set_productions
      case current_user.user_type
      when "Administrator"
        @productions = Production.all
      when "Designer"
        @productions = current_user.designed_productions
      when "ME"
        @productions = current_user.master_electrician_productions
      when "Lead"
        @productions = current_user.lead_productions
    end
    end
end
