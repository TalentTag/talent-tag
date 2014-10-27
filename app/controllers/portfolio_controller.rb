class PortfolioController < ApplicationController

  def create
    current_user.portfolio.create create_params
    redirect_to account_path, notice: "Ссылка добавлена в портфолио"
  end

  def destroy
    current_user.portfolio.find(params[:id]).destroy
    redirect_to account_path, notice: "Ссылка удалена из портфолио"
  end


  protected

  def create_params
    params[:portfolio].update href: "http://#{ params[:portfolio][:href] }" unless params[:portfolio][:href].include? 'http://'
    params.require(:portfolio).permit %i(title href)
  end

end
