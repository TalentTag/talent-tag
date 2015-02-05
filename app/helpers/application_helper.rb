module ApplicationHelper

  def bold_tags line
    line.gsub(/#(\S+)/) { |capture| content_tag :b, capture }
  end

  def icon icon
    content_tag :i, nil, class: "icon-#{ icon }"
  end

  def russian_date date, format
    date = Date.parse(date) unless date.kind_of?(Date)
    Russian::strftime date, format
  end

end
