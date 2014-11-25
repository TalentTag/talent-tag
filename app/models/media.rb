class Media < ActiveRecord::Base

  default_scope -> { order id: :desc }


  def self.tags
    all.flat_map(&:tags).uniq.sort rescue []
  end

end
