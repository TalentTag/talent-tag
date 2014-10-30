class Admin::IndustriesController < Admin::BaseController

  respond_to :json

  before_action { authorize! :update, :dictionaries }
  before_action :find_industry, except: :create


  def create
    respond_with :admin, Industry.create(name: params[:name])
  end

  def update
    respond_with @industry.update name: params[:name]
  end

  def destroy
    respond_with @industry.destroy
  end


  private

  def find_industry
    @industry = Industry.find_by! id: params[:id]
  end

end
