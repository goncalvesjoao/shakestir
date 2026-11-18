module TagsHelper
  MAIN_STYLES = {
    default: "content-grid my-2 my-md-3 py-3",
    with_hero: "mb-2 mb-md-3 pb-3",
    plain: "my-2 my-md-3 py-3"
  }
  HEADER_STYLES = {
    default: "nav border-bottom pb-d mb-4",
    plain: "nav",
  }

  def icon_svg_tag(name, **options)
    # https://github.com/jamesmartin/inline_svg
    options[:class] = class_names("icon", options[:class])

    inline_svg_tag("icons/#{name}.svg", **options)
  end

  def icon_tag(name, **options)
    text = options.delete(:text)

    icon_svg_tag(name, **options) + (text.present? ? tag.span(text, class: "ms-1") : "")
  end

  def main_tag(options = {}, &block)
    style = options.delete(:style) || :default
    options[:class] = class_names(MAIN_STYLES[style] || "", options[:class])

    content_tag :main, options, &block
  end

  def header_tag(options = {}, &block)
    style = options.delete(:style) || :default
    options[:class] = class_names(HEADER_STYLES[style] || "", options[:class])

    content_tag :header, options, &block
  end

  def article_tag(options = {}, &block)
    content_tag :article, options, &block
  end

  def aside_tag(options = {}, &block)
    content_tag :aside, options, &block
  end

  def sidebar_tag(base_id, options = {}, &block)
    options[:class] = class_names("sidebar", "bg-secondary w-50 position-fixed", options[:class])
    options[:hidden] ||= "hidden"
    options[:popover] ||= ""
    options[:id] = "#{base_id}-sidebar"

    aside_tag options, &block
  end

  def right_sidebar_tag(base_id, options = {}, &block)
    options[:data] ||= {}
    options[:data][:placement] = "right"

    sidebar_tag(base_id, options, &block)
  end

  def dialog_tag(base_id, options = {}, &block)
    content_tag :dialog, options.merge(id: "#{base_id}-dialog"), &block
  end

  def modal_tag(base_id, options = {}, &block)
    options[:class] = class_names("card", options[:class])

    dialog_tag base_id, options, &block
  end

  def turbo_frame_tag(base_id, options = {}, &block)
    content_tag "turbo-frame", options.merge(id: "#{base_id}-frame"), &block
  end
end
