module SocialNetworks

  NETWORKS = %i(vk twitter facebook gplus linkedin)

  class << self
    def all
      NETWORKS
    end

    alias company all
    alias oauth all
  end

end
