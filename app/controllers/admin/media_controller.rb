class Admin::MediaController < Admin::BaseController

  def create
    Media.create whitelisted_params
    redirect_to admin_media_path
  end

  def edit
    @medium = Media.find_by! id: params[:id]
  end

  def update
    Media.update params[:id], whitelisted_params
    redirect_to admin_media_path
  end

  def destroy
    Media.destroy params[:id]
    redirect_to admin_media_path
  end


  protected

  def whitelisted_params
    params[:media][:tags] = params[:media][:tags].split(',').map &:strip
    params.require(:media).permit(:title, :source, :published_at, :link, :tags).tap do |whitelisted|
      whitelisted[:tags] = params[:media][:tags]
    end
  end

end
