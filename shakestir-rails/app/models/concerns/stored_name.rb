module StoredName
  extend ActiveSupport::Concern

  included do
    before_validation { self.normalized_name = name.present? ? LookupName.normalize(name) : nil }
  end

  class_methods do
    def search(text)
      return all if text.blank?

      pattern = "%#{sanitize_sql_like(LookupName.normalize(text))}%"
      where("#{table_name}.normalized_name LIKE ?", pattern)
    end
  end
end
