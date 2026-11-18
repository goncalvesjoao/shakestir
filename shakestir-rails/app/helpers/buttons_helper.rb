module ButtonsHelper
  def close_button(options = {}, &block)
    options[:aria] ||= {}
    options[:aria][:label] ||= "Close"
    options[:class] ||= "icon-close align-self-start"

    content_tag(:button, "", options, &block)
  end

  def close_dialog_button(base_id, options = {}, &block)
    options[:aria] ||= {}
    options[:aria][:label] ||= "Close"
    options[:class] ||= "icon-close align-self-start"
    options[:commandfor] ||= "#{base_id}-dialog"
    options[:command] ||= "close"

    close_button(options, &block)
  end
end
