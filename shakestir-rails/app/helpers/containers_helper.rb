module ContainersHelper
  COMPACT_ARTICLE_CLASSES = "mx-0 mx-md-4 px-0 px-md-4"

  def main_article(options = {}, &block)
    options[:class] = class_names("my-2 my-md-3 py-3", options[:class] || "")

    article_tag options, &block
  end

  def hero_article(options = {}, &block)
    options[:class] = class_names("full-width mb-2 mb-md-3 pb-3", options[:class] || "")

    article_tag options, &block
  end

  def compact_article(options = {}, &block)
    options[:class] = class_names("my-2 my-md-3 py-3", COMPACT_ARTICLE_CLASSES, options[:class] || "")

    article_tag options, &block
  end

  def border_header(options = {}, &block)
    options[:class] = class_names("nav border-bottom pb-d mb-4", options[:class] || "")

    content_tag :header, options, &block
  end
end
