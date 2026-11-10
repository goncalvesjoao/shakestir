# Run after scripts/normalize_catalog_images.py:
# bin/rails runner script/refresh_catalog_images.rb /path/to/manifest.json
# Only replace attachments whose bytes match the original seed image.
require "json"
require "stringio"

entries = JSON.parse(File.read(ARGV.fetch(0)))
updated = 0
entries.each do |entry|
  path = Rails.root.parent.join(entry.fetch("path"))
  ActiveStorage::Blob.where(checksum: entry.fetch("old_checksum")).find_each do |blob|
    blob.attachments.where(name: "image", record_type: %w[Cocktail Recipe Ingredient Utensil]).each do |attachment|
      attachment.record.image.attach(io: StringIO.new(path.binread), filename: path.basename.to_s, content_type: "image/png")
      updated += 1
    end
  end
end
puts "Updated #{updated} matching catalog image attachments."
