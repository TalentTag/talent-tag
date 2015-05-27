module PrepareQuery
  extend ActiveSupport::Concern

  MAX_RESULTS = 100_000

  module ClassMethods
    def search_query(term)
      KeywordGroup.query_str term
    end

    def prepare_opts(params, opts = {})
      location_id = Location.first_by_name(params[:location]) if params[:location].present?

      {
        conditions: {
          profile_location: (params[:location] if params[:location].present? && !location_id)
        }.merge!(opts[:conditions] || {}),
        with: {
          location_id: location_id
        }.merge!(opts[:filters] || {}),
        without: opts[:excepts],
        retry_stale: true, #retry_stale: 1
        excerpts: { around: 250 },
        order: 'created_at DESC'
      }.neat
    end

  end

end
