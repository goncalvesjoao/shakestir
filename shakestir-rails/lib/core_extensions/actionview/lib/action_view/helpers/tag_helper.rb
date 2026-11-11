# frozen_string_literal: true

module ActionView
  module Helpers # :nodoc:
    module TagHelper
      class TagBuilder # :nodoc:
        def self.define_void_element(name, code_generator:, method_name: name.to_s.underscore)
          code_generator.define_cached_method(method_name, namespace: :tag_builder) do |batch|
            batch.push(<<~RUBY)
              def #{method_name}(content = nil, escape: true, **options, &block)
                if content || block
                  ActionView.deprecator.warn <<~TEXT
                    Putting content inside a void element (#{name}) is invalid
                    according to the HTML5 spec, and so it is being deprecated
                    without replacement. In Rails 7.3, passing content as a
                    positional argument will raise, and using a block will have
                    no effect.
                  TEXT
                  tag_string("#{name}", content, options, escape: escape, &block)
                else
                  self_closing_tag_string("#{name}", options, escape, ">")
                end
              end
            RUBY
          end
        end
      end

      def tag(name = nil, options = nil, open = nil, escape = true)
        if name.nil?
          tag_builder
        else
          ensure_valid_html5_tag_name(name)

          "<#{name}#{tag_builder.tag_options(options, escape) if options}#{" /" if open == false}>".html_safe
        end
      end
    end
  end
end
