class Hash
  def neat
    self.delete_if do |key, val|
      val.is_a?(Hash) ? !val.neat : val.nil?
    end
  end
end
