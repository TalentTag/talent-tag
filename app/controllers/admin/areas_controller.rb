class Admin::AreasController < Admin::BaseController

  respond_to :json
  before_action :find_area, except: :create


  def create
    respond_with :admin, Area.create(name: params[:name])
  end

  def update
    respond_with @area.update name: params[:name]
  end

  def destroy
    respond_with @area.destroy
  end


  private

  def find_area
    @area = Area.find_by! id: params[:id]
  end

end
