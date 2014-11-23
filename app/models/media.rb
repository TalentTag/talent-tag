class Media < ActiveRecord::Base

  scope :newest, ->{ order id: :desc }


  def self.tags
    all.flat_map(&:tags).uniq
  end

end
