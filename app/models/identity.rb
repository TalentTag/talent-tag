class Identity < ActiveRecord::Base

  belongs_to :user
  accepts_nested_attributes_for :user


  def self.from_omniauth params
    find_by(params.slice :provider, :uid) || begin
      password = Digest::MD5.hexdigest(Time.now.to_s + params[:uid] + params[:provider])
      params[:user_attributes][:password] = params[:user_attributes][:password_confirmation] = password
      identity = new params
      identity if identity.save
    end
  end

end
