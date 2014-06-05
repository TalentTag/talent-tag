module B2cHelper

  def oauth_providers
    TalentTag::Application::PROVIDERS
  end


  def embedded_identity provider, name
    if current_user.identities.exists?(provider: provider)
      link_to name, current_user.profile["url_#{ provider }"], target: "_blank"
    else
      link_to "Подключить #{ name }", "/auth/#{ provider }", title: name
    end
  end


  def work_positon data
    render partial: 'b2c/partials/work', locals: { data: data }
  end

end
