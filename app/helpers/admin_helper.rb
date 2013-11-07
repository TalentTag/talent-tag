module AdminHelper

  def badge count
    content_tag(:span, count) unless count.zero?
  end

end
