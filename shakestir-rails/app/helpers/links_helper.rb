module LinksHelper
  def link_to_top(name = nil, url_options = nil, html_options = nil, &block)
    html_options, url_options, name = url_options, name, block if block_given?
    url_options ||= {}

    html_options = convert_options_to_data_attributes(url_options, html_options)

    html_options[:data] ||= {}
    html_options[:data][:turbo_frame] = "_top"

    if block_given?
      link_to(url_options, html_options, &block)
    else
      link_to(name, url_options, html_options)
    end
  end

  def modal_link_to(name = nil, url_options = nil, html_options = nil, &block)
    html_options, url_options, name = url_options, name, block if block_given?
    url_options ||= {}
    modal = html_options.delete(:modal) if html_options.is_a?(Hash)
    
    html_options = convert_options_to_data_attributes(url_options, html_options)

    url = url_target(name, url_options)
    html_options["href"] ||= url

    if modal.present?
      html_options["onclick"] = "document.getElementById('#{modal}-dialog').showModal(); return false"

      return content_tag("a", name || url, html_options, &block) + dialog_tag(modal) do
        turbo_frame_tag(modal, src: url, loading: "lazy", class: "card d-block") {}
      end
    end

    content_tag("a", name || url, html_options, &block)
  end

  def sidebar_link_to(name = nil, url_options = nil, html_options = nil, &block)
    html_options, url_options, name = url_options, name, block if block_given?
    url_options ||= {}
    sidebar = html_options.delete(:sidebar) if html_options.is_a?(Hash)
    
    html_options = convert_options_to_data_attributes(url_options, html_options)

    url = url_target(name, url_options)
    html_options["href"] ||= url

    if sidebar.present?
      html_options["onclick"] = "document.getElementById('#{sidebar}-sidebar').showPopover(); return false"

      store_content("sidebars", right_sidebar_tag(sidebar) do
        turbo_frame_tag(sidebar, src: url, loading: "lazy") {}
      end)
    end

    content_tag("a", name || url, html_options, &block)
  end
end
