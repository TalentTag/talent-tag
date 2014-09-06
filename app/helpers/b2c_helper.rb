module B2cHelper

  def oauth_providers
    TalentTag::Application::PROVIDERS
  end


  def embedded_identity user, provider, name, &block
    if user.identities.exists?(provider: provider)
      link_to(user.profile["url_#{ provider }"], target: "_blank", title: name, class: "social-round #{ provider }") { block.call }
    else
      if @user==current_user
        link_to("/auth/#{ provider }", target: "_self", title: name, class: "social-round disabled") { block.call }
      end
    end
  end


  def work_positon data
    render partial: 'b2c/partials/work', locals: { data: data }
  end


  def owns_account? user
    !!@owns_account
  end

end
