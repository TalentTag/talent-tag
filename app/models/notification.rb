class Notification < ActiveRecord::Base
  
  self.inheritance_column = :source

  default_scope -> { order created_at: :desc }


  def self.find_sti_class units
    unit_class_for[units]
  end

  def self.sti_name
    unit_class_for.invert[self]
  end

  def self.unit_class_for
    {
      'user'        => Notification::Users,
      'specialist'  => Notification::Specialists
    }
  end

end
