class PortfolioController < ApplicationController

  respond_to :json


  def create
    link = current_user.portfolio.create create_params
    respond_with link, status: :created
  end

  def destroy
    current_user.portfolio.find(params[:id]).destroy
    render nothing: true, status: :no_content
  end


  protected

  def create_params
    params[:portfolio].update href: "http://#{ params[:portfolio][:href] }" unless params[:portfolio][:href].include? 'http'
    params.require(:portfolio).permit %i(title href)
  end

end
