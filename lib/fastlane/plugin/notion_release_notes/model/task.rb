require_relative './property'
require_relative './item'

module Fastlane
  module Actions
    class Task < Item
      def initialize(original_data)
        super
      end

      def format_line
        line_url = @public_url || @url
        line_id = ""
        line_id = "[#@unique_id](#{line_url}) " if @unique_id != nil

        line_title = @title.to_s
        line_title = "[#{title}](#{line_url})" if @unique_id == nil

        "#{line_id}#{line_title}"
      end
    end
  end
end