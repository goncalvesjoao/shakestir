module LinksHelper
  def modal_link_to(name = nil, url_options = nil, html_options = nil, &block)
    html_options, url_options, name = url_options, name, block if block_given?
    url_options ||= {}
    modal = html_options.delete(:modal) if html_options.is_a?(Hash)
    
    html_options = convert_options_to_data_attributes(url_options, html_options)

    url = url_target(name, url_options)
    html_options["href"] ||= url

    if modal.present?
      html_options["onclick"] = "document.getElementById('#{modal}-modal').showModal(); return false"

      return content_tag("a", name || url, html_options, &block) + content_tag("dialog", id: "#{modal}-modal", class: "py-0") do
        content_tag("turbo-frame", id: "#{modal}-frame", src: url, loading: "lazy", class: "card p-0") {}
      end
    end

    content_tag("a", name || url, html_options, &block)
  end
end
