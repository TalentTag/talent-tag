class Admin::LocationsController < Admin::BaseController

  respond_to :json, except: :index

  before_action :find_locaton, only: [:update, :destroy]

  def index
    @locations = Location.order(:name)
    gon.push locations: Location.all
  end

  def create
    respond_with :admin, Location.create(name: params[:name])
  end

  def update
    respond_with @location.update(name: params[:name])
  end

  def destroy
    respond_with @location.destroy
  end

  private

  def find_locaton
    @location = Location.find_by! id: params[:id]
  end

end
