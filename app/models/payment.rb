class Payment < ActiveRecord::Base

  include AASM

  IDENTIFIER_CHARS = (('A'..'Z').to_a + ('0'..'9').to_a - %w(0 1 I O)).freeze

  scope :with_state, ->(s) { where(state: s.to_s) }
  scope :completed, -> { with_state('completed') }
  scope :pending, -> { with_state('pending') }
  scope :processing, -> { with_state('processing') }
  scope :failed, -> { with_state('failed') }

  has_paper_trail only: [:state, :user_id]
  #TODO: admin page to watch payments processing and changing

  before_create :set_unique_identifier

  # STATES:
  # click on Buy button
  # 1. fill billing form, payment not created yet
  # 2. click process, create pending payment
  # if information given valid
  #   3. trying to process payment, state changes to processing
  #   4. after payment been processed, state changes to completed
  # else 
  #   3. state changes to invalid

  aasm do
    state :pending, initial: true
    state :confirmed
    state :processing
    state :completed, before_enter: :do_complete
    state :failed
    state :invalid

    event :pend do
      transitions to: :pending, from: [:processing]
    end

    event :started_processing do
      transitions to: :processing, from: [:pending, :processing, :completed, :confirmed]
    end

    event :failture do
      transitions to: :failed, from: [:pending, :processing]
    end

    event :confirm do
      transitions to: :confirmed, from: :pending
    end

    event :complete do
      transitions to: :completed, from: [:confirmed, :processing]
    end
  end

  def do_complete
  end

  private

    def set_unique_identifier
      begin
        self.identifier = generate_identifier
      end while self.class.exists?(identifier: self.identifier)
    end

    def generate_identifier
      Array.new(8){ IDENTIFIER_CHARS.sample }.join
    end

end
