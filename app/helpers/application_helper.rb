module ApplicationHelper

  def bold_tags line
    line.gsub(/#(\S+)/) { |capture| content_tag :b, capture }
  end

end
