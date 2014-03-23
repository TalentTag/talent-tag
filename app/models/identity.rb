class Identity < ActiveRecord::Base

  belongs_to :user
  accepts_nested_attributes_for :user


  def self.from_omniauth params, user=nil
    data = params.slice :provider, :uid
    find_by(data) || begin
      data[:anchor] = send("anchor_#{ params[:provider] }", params)
      if user
        identity = new data
        identity.user = user
        identity if identity.save(validate: false)
      else
        password = Digest::MD5.hexdigest(Time.now.to_s + params[:uid] + params[:provider])
        data[:user_attributes][:password] = data[:user_attributes][:password_confirmation] = password
        identity = new data
        identity if identity.save
      end
    end
  end


  protected

  def self.anchor_facebook params
    "http://www.facebook.com/profile.php?id=#{ params[:uid] }"
  end

  def self.anchor_twitter params
    "http://twitter.com/#{ params[:info]['nickname'] }"
  end

  def self.anchor_vkontakte params
    params[:uid]
  end

  def self.anchor_google_oauth2 params
    "https://plus.google.com/#{ params[:uid] }"
  end

end
