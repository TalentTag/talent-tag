class Identity < ActiveRecord::Base

  belongs_to :user
  accepts_nested_attributes_for :user

  after_create :generate_anchor, :link_entries


  def hashtags
    entries.flat_map(&:hashtags).uniq
  end


  def self.from_omniauth params, user=nil
    data = params.slice :provider, :uid
    find_by(data) || begin
      data[:user_attributes] = params[:user_attributes] || {}
      if user
        identity = new data

        profile = Identity.generate_profile(params)
        user.firstname  = profile[:firstname] unless user.firstname.present?
        user.lastname   = profile[:lastname] unless user.lastname.present?
        user.profile    = user.profile.reverse_merge profile[:profile]
        user.save
        
        identity.user = user
        identity
      else
        password = Digest::MD5.hexdigest(Time.now.to_s + params[:uid] + params[:provider])
        data[:user_attributes][:password] = data[:user_attributes][:password_confirmation] = password
        data[:user_attributes].merge! Identity.generate_profile(params)
        new data
      end
    end
  end


  def generate_anchor
    update anchor: send("anchor_#{ provider }")
  end

  def generate_profile params
    Identity.generate_profile params
  end

  def self.generate_profile params
    send("profile_#{ params.delete :provider }", params)
  end



  protected

  def link_entries
    Entry.where("author->> 'guid' = '#{ anchor }'").update_all user_id: user.id
  end



  def anchor_facebook
    "http://www.facebook.com/profile.php?id=#{ uid }"
  end

  def anchor_twitter
    "http://twitter.com/#{ user.profile['nickname'] }"
  end

  def anchor_vkontakte
    "http://vk.com/id#{ uid }"
  end

  def anchor_google_oauth2
    "https://plus.google.com/#{ uid }"
  end

  def anchor_linkedin
    user.profile['url_linkedin'] || user.profile[:url_linkedin]
  end



  def self.profile_facebook params
    {
      firstname: params[:info]['first_name'],
      lastname: params[:info]['last_name'],
      profile: {
        location: params[:info]['location'],
        image: params[:info]['image'],
        education: params[:extra]['raw_info']['educaton'],
        work: params[:extra]['raw_info']['work'],
        url_facebook: params[:info]['urls']['Facebook']
      }
    }
  end

  def self.profile_twitter params
    name = params[:info]['name'].split
    {
      firstname: name.first,
      lastname: name.last,
      profile: {
        location: params[:info]['location'],
        image: params[:info]['image'],
        nickname: params[:info]['nickname'],
        url_twitter: params[:info]['urls']['Twitter']
      }
    }
  end

  def self.profile_vkontakte params
    {
      firstname: params[:info]['first_name'],
      lastname: params[:info]['last_name'],
      profile: {
        location: params[:info]['location'],
        image: params[:extra]['raw_info']['photo_200_orig'],
        birthdate: params[:extra]['raw_info']['bdate'],
        url_vkontakte: params[:info]['urls']['Vkontakte']
      }
    }
  end

  def self.profile_google_oauth2 params
    {
      firstname: params[:info]['first_name'],
      lastname: params[:info]['last_name'],
      profile: {
        image: params[:info]['image'],
        url_google_oauth2: params[:info]['urls']['Google']
      }
    }
  end

  def self.profile_linkedin params
    {
      firstname: params[:info]['first_name'],
      lastname: params[:info]['last_name'],
      profile: {
        location: params[:info]['location'],
        image: params[:info]['image'],
        phone: params[:info]['phone'],
        url_linkedin: params[:info]['urls']['public_profile']
      }
    }
  end

end
