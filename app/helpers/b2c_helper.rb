module B2cHelper

  def oauth_providers
    TalentTag::Application::PROVIDERS
  end


  def embedded_identity provider, name
    begin
      "#{ name } #{ content_tag :b, current_user.identities.where(provider: provider).first.uid }"
    rescue NoMethodError
      link_to "Подключить #{ name }", "/auth/#{ provider }", title: name
    end
  end

end
