Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :developer unless Rails.env.production?

  provider :facebook, "176776305712139", "ddc868dc01d6ce0a6504d8f226e1ec0c"
  provider :twitter, "5E7GchtEUZDfSi4Azz87w", "N9onKDLHbvKTNb0m4nICF1pYr3g0KX6pl89kphbo1M"
  provider :vkontakte, "4201311", "5qFEBPOnhd4aFAOCS4Eh"
  provider :google_oauth2, "428047194229-mgif4uclcvujg0bma1d2lr2i57lp80s4.apps.googleusercontent.com", "NOQvqMpHpfI1eZpkJfVWJUlM"
end
