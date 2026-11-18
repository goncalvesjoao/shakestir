module StoresHelper
  def store_content(key, content)
    @stored_content ||= {}
    @stored_content[key] ||= []

    @stored_content[key].push(content)
  end

  def read_content(key)
    @stored_content ||= {}

    (@stored_content[key] || []).join.html_safe
  end
end
