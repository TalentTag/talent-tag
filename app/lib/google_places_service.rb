class GooglePlacesService

  def initialize
    @client = GooglePlacesAutocomplete::Client.new(api_key: ENV['google_places_key'])
  end

  attr_reader :client

  def predict_location(term)
    result = @client.autocomplete(input: term, types: '(cities)')

    best_match = result.predictions.first if result && result.status == "OK"

    {
      'google_place_id' => best_match.try(:place_id),
      'google_place_description' => best_match.try(:description)
    }
  end
end
