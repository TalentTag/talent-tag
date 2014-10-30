module B2cHelper

  def oauth_providers provider=nil
    if provider
      TalentTag::Application::OAUTH_PROVIDERS[provider]
    else
      TalentTag::Application::OAUTH_PROVIDERS
    end
  end


  def embedded_identity user, provider, name, &block
    provider_name = oauth_providers(provider)['name']
    if user.identities.exists?(provider: provider_name)
      link_to user.profile["url_#{ provider_name }"], { target: "_self", title: name, class: "social-round #{ provider }" } { block.call }
    else
      if @user==current_user
        link_to("/auth/#{ provider_name }", target: "_self", class: "social-round disabled") { block.call }
      end
    end
  end


  def owns_account? user
    !!@owns_account
  end

end
