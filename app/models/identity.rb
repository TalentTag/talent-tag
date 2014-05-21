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
        profile_data = send("profile_#{ params[:provider] }", params)
        p profile_data
        user.profile = user.profile.reverse_merge profile_data
        if identity.save(validate: false)
          user.save
          identity
        end
      else
        password = Digest::MD5.hexdigest(Time.now.to_s + params[:uid] + params[:provider])
        data[:user_attributes][:password] = data[:user_attributes][:password_confirmation] = password
        userdata = send("profile_#{ params[:provider] }", params)
        # p userdata
        # data[:user_attributes].reverse_merge! send("profile_#{ params[:provider] }", params)
        data[:user_attributes].reverse_merge! userdata
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



  def self.profile_twitter params
    name = params[:info]['name'].split
    {
      firstname: name.first,
      lastname: name.last,
      location: params[:info]['location'],
      image: params[:info]['image']
    }
  end

  def self.profile_facebook params
    info = params[:info]
    {
      firstname: info['first_name'],
      lastname: info['last_name'],
      location: info['location'],
      image: info['image']
    }
  end

  def self.profile_vkontakte params
    {
      firstname: params[:info]['first_name'],
      lastname: params[:info]['last_name'],
      location: params[:info]['location'],
      image: params[:extra]['raw_info']['photo_200_orig'],
      birthdate: params[:extra]['raw_info']['bdate']
    }
  end

  def self.profile_google_oauth2 params
    {
      firstname: params[:info]['first_name'],
      lastname: params[:info]['last_name'],
      image: params[:info]['image']
    }
  end

end
