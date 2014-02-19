class Admin::KeywordGroupsController < Admin::BaseController

  respond_to :json

  before_action :find_keyword_group, except: :create


  def create
    respond_with :admin, KeywordGroup.create(permitted_params)
  end

  def update
    respond_with :admin, @keywordGroup.update(permitted_params)
  end

  def destroy
    respond_with @keywordGroup.destroy
  end


  private

  def permitted_params
    params.require(:keyword_group).permit(:keywords, :industry_id, :area_id).tap do |whitelisted|
      whitelisted[:keywords] = params[:keyword_group][:keywords]
    end
  end

  def find_keyword_group
    @keywordGroup = KeywordGroup.find_by!(id: params[:id])
  end

end
