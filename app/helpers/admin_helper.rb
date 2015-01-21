module AdminHelper

  def badge count
    content_tag(:span, count) unless count.zero?
  end

  def years
    (2013..Date.today.year).to_a
  end

  def months
    (1..12).map { |n| [Date::MONTHNAMES[n], n] }
  end

end
