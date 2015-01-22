module AdminHelper

  def badge count
    content_tag(:span, count) unless count.zero?
  end

  def years start_date=2013
    (start_date..Date.today.year).to_a.reverse
  end

  def months
    (1..12).map { |n| [Date::MONTHNAMES[n], n] }
  end

  def days month, year
    (1..Time.days_in_month(month, year)).to_a
  end

end
