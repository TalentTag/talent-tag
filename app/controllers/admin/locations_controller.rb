class Admin::LocationsController < Admin::BaseController

  respond_to :json, except: :index

  before_action :find_locaton, only: [:update, :destroy]

  def index
    @locations = Location.order(:name)
    gon.push locations: Location.all
  end

  def create
    if place = Location.create(location_params)
      UpdateLocationsWorker.perform_async

      respond_with :admin, place
    end
  end

  def update
    if @location.update(location_params)
      UpdateLocationsWorker.perform_async true

      respond_with @location
    end
  end

  def destroy
    if @location.destroy
      UpdateLocationsWorker.perform_async true

      respond_with @location
    end
  end

  private

  def location_params
    params.require(:location).permit(:name, synonyms: [])
  end

  def find_locaton
    @location = Location.find_by! id: params[:id]
  end

end
