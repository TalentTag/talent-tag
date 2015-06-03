class UpdateLocationsWorker

  include Sidekiq::Worker

  def perform(reassign = false)
    Entry.update_locations reassign
    Specialist.update_locations reassign
  end
end
