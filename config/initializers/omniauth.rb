# Rails.application.config.middleware.use OmniAuth::Builder do
#   provider :developer unless Rails.env.production?
#   provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
# end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, "5E7GchtEUZDfSi4Azz87w", "N9onKDLHbvKTNb0m4nICF1pYr3g0KX6pl89kphbo1M"
end

# twitter:
#   id: '5E7GchtEUZDfSi4Azz87w'
#   secret: 'N9onKDLHbvKTNb0m4nICF1pYr3g0KX6pl89kphbo1M'

# facebook:
#   id: '176776305712139'
#   secret: 'ddc868dc01d6ce0a6504d8f226e1ec0c'
