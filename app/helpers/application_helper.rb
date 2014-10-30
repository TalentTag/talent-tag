module ApplicationHelper

  def bold_tags line
    line.gsub(/#(\S+)/) { |capture| content_tag :b, capture }
  end

  def icon icon
    content_tag :i, nil, class: "icon-#{ icon }"
  end

end
