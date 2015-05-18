class Specialist < ActiveRecord::Base

  include UserConcern
  include PrepareQuery

  ENTRIES_PER_PAGE = 10
  paginates_per ENTRIES_PER_PAGE


  has_many :followings
  has_and_belongs_to_many :followed_by, class_name: 'User'
  has_many :identities, foreign_key: :user_id, dependent: :destroy
  has_many :entries, foreign_key: :user_id
  has_many :portfolio, foreign_key: :user_id
  has_many :notifications, class_name: 'Notification::Specialists', foreign_key: :author_id

  sifter :location_match do |term|
    profile_location.matches "%#{ term.neat.downcase }%"
  end
  scope :location_like, ->(term) { where{ sift :location_match, term } }

  scope :with_location, -> { where{ (profile_location.not_eq nil) | (location_id.not_eq nil) } }

  after_create :send_signup_notification
  after_update :notify

  STATUSES = %w(ignore active passive)


  def type() :specialist end


  def self.filter params={}
    page = params[:page] || 1

    location_id = Location.first_by_name(params[:location]) if params[:location].present?

    location_param = params[:location] if params[:location].present? && !location_id

    conditions = {
      tags: search_query(params[:query]),
      profile_location: location_param
    }.delete_if{ |k, v| v.nil? }

    filters = {
      location_id: location_id
    }.delete_if { |k, v| v.nil? }

    users = Specialist.search(
      conditions: conditions,
      with: filters,
      order: 'created_at DESC'
    )

    users.page(page).per(ENTRIES_PER_PAGE)
  end


  def send_signup_notification
    AuthMailer.signup_specialist(self).deliver
  end

  def notify
    notifications.create(event: "status_change", data: { from: status_was, to: status }) if status_changed?
  end

  def ban! state=true
    update can_login: !state
  end

  def self.update_profile_locations
    Specialist.find_each do |person|
      person.update(profile_location: person.profile['location']) if person.profile['location']
    end
  end

  def self.update_locations(reassign = false)
    Specialist.update_all(location_id: nil) if reassign

    Location.find_each do |place|
      querystring = place.synonyms.map { |e| "\"#{ e }\"" }.join(' | ')

      options = {
        with: { location_id: 0 }
      }

      options.clear if reassign

      ids = Specialist.search_for_ids(
        options.merge(
          conditions: { profile_location: querystring },
          limit: MAX_RESULTS
        )
      )

      scope = Specialist.where(id: ids)
      scope = Specialist.where(location_id: nil) unless reassign
      scope.update_all(location_id: place.id)
    end
  end

end
