class Payment < ActiveRecord::Base

  include AASM

  IDENTIFIER_CHARS = (('A'..'Z').to_a + ('0'..'9').to_a - %w(0 1 I O)).freeze

  scope :with_state, ->(s) { where(state: s.to_s) }
  scope :completed, -> { with_state('completed') }
  scope :pending, -> { with_state('pending') }
  scope :processing, -> { with_state('processing') }
  scope :failed, -> { with_state('failed') }
  default_scope -> { order(created_at: :desc).limit(30) }

  # has_paper_trail only: [:state, :user_id]
  #TODO: admin page to watch payments processing and changing

  before_create :set_unique_identifier

  belongs_to :company
  def plan() Plan.find plan_id end


  aasm_column :state
  aasm do
    state :pending, initial: true
    state :confirmed
    state :processing
    state :completed, after_enter: :complete_callback
    state :failed
    state :invalid

    event :pend do
      transitions to: :pending, from: [:processing]
    end

    event :started_processing do
      transitions to: :processing, from: [:pending, :processing, :completed, :confirmed]
    end

    event :fail do
      transitions to: :failed, from: [:pending, :processing]
    end

    event :confirm do
      transitions to: :confirmed, from: :pending
    end

    event :complete do
      transitions to: :completed, from: [:confirmed, :processing]
    end
  end


  def complete_callback
    company.go_premium! plan
  end


  private

  def set_unique_identifier
    begin
      self.identifier = Array.new(8){ IDENTIFIER_CHARS.sample }.join
    end while self.class.exists?(identifier: self.identifier)
  end

end
