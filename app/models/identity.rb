class Identity < ActiveRecord::Base

  belongs_to :user
  accepts_nested_attributes_for :user


  def self.from_omniauth params, user=nil
    data = params.slice :provider, :uid
    find_by(data) || begin
      data[:anchor] = send("anchor_#{ params[:provider] }", params)
      data[:user_attributes] = params[:user_attributes] || {}
      if user
        identity = new data
        identity.user = user
        if identity.save(validate: false)
          user.update identity.download_profile
          identity
        end
      else
        password = Digest::MD5.hexdigest(Time.now.to_s + params[:uid] + params[:provider])
        data[:user_attributes][:password] = data[:user_attributes][:password_confirmation] = password
        identity = new data
        identity if identity.save
      end
    end
  end


  def download_profile
    send("profile_#{ provider }")
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



  def profile_facebook
    # token = TalentTag::Application::PROVIDERS[:facebook][:app_id]
    # @graph = Koala::Facebook::API.new(token)
    # raise profile = @graph.get_object("me").to_yaml

    # info = params[:info]
    # {
    #   firstname: info['first_name'],
    #   lastname: info['last_name'],
    #   location: info['location'],
    #   image: info['image']
    # }
  end

  def profile_twitter
    # name = params[:info]['name'].split
    # {
    #   firstname: name.first,
    #   lastname: name.last,
    #   profile: {
    #     location: params[:info]['location'],
    #     image: params[:info]['image']
    #   }
    # }
  end

  def profile_vkontakte
    data = VkontakteApi::Client.new.users.get(uid: uid, fields: %w(birthdate location photo_big contacts education)).first
    {
      firstname: data.first_name,
      lastname: data['last_name'],
      profile: {
        image: data['photo_big'],
        birthdate: data['bdate']
      }
    }
  end

  def profile_google_oauth2
    # {
    #   firstname: params[:info]['first_name'],
    #   lastname: params[:info]['last_name'],
    #   image: params[:info]['image']
    # }
  end

end
