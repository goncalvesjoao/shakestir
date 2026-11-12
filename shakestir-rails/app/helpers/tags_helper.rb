module TagsHelper
  def icon_svg_tag(name, **options)
    # https://github.com/jamesmartin/inline_svg
    options[:class] = class_names("icon", options[:class])

    inline_svg_tag("icons/#{name}.svg", **options)
  end

  def icon_tag(name, **options)
    text = options.delete(:text)

    icon_svg_tag(name, **options) + (text.present? ? tag.span(text, class: "ms-1") : "")
  end
end
