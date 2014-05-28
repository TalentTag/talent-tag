module B2cHelper

  def oauth_providers
    TalentTag::Application::PROVIDERS
  end


  def embedded_identity provider, name
    if current_user.identities.find_by(provider: provider)
      "#{ name } [#{ content_tag :a, 'sync', href: auth_bind_provider_path(provider: provider) }]" # TODO index :provider field
    else
      link_to "Подключить #{ name }", "/auth/#{ provider }", title: name
    end
  end

end
