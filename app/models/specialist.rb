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

  after_create :send_signup_notification
  before_update :touch
  after_update :notify
  before_save :update_location_from_profile, if: :profile_changed?
  before_save :update_location, if: :profile_location_changed?

  STATUSES = %w(ignore active passive)


  def type() :specialist end


  def self.filter params={}
    Specialist
      .search(prepare_opts params, {
          conditions: {
            tags: search_query(params[:query]),
          },
          order: "changed_at DESC"
        }
      )
      .page(params[:page] || 1)
      .per(ENTRIES_PER_PAGE)
  end


  def send_signup_notification
    AuthMailer.signup_specialist(self).deliver_now
  end

  def ban! state=true
    update can_login: !state
  end

  def update_location_from_profile
    unless self.new_record?
      self.update_column :profile_location, profile['location']

      self.update_location
    end
  end

  def update_location
    unless self.new_record?
      update_column(:location_id, profile_location && Location.search_for_ids(profile_location).first)
    end
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


  protected

  def notify
    notifications.create(event: "status_change", data: { from: status_was, to: status }) if status_changed?
  end

  def touch
    self.changed_at = Time.now if status_changed? || tags_changed?
  end

end
