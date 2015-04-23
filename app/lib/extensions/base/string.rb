class String
  def single?
    !(self.strip =~ /\s/)
  end

  def neat
    strip.gsub(/\s+/, ' ')
  end

  def to_bool
    return true if self == true || self =~ (/^(true|t|yes|y|1)$/i)
    return false if self == false || self.blank? || self =~ (/^(false|f|no|n|0)$/i)
    fail ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
end
