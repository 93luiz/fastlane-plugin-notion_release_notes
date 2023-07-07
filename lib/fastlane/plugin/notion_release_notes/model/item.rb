require_relative './property'

module Fastlane
  module Actions
    class Item
      Hash @original_data = {}
      Hash @properties = {}
      @title = nil
      @unique_id = nil
      String @id = nil
      String @created_time = nil
      String @last_edited_time = nil
      String @url = nil
      String @public_url = nil

      attr_reader :original_data
      attr_reader :properties
      attr_reader :title
      attr_reader :unique_id
      attr_reader :id
      attr_reader :created_time
      attr_reader :last_edited_time
      attr_reader :url
      attr_reader :public_url

      def initialize(original_data)
        @original_data = original_data
        @properties = original_data.properties.map { |name, data| [name, Property.create(data, name)] }.to_h
        @title = @properties.select { |k, item| item.is_a?(Title) }.values[0]

        unique_id_list = @properties.select { |k, item| item.is_a?(UniqueId) }.values
        if !unique_id_list.empty? then
          @unique_id = unique_id_list[0]
        end

        @id = original_data.id
        @created_time = original_data.created_time
        @last_edited_time = original_data.last_edited_time
        @url = original_data.url
        @public_url = original_data.public_url
      end

      def get_property(property_id)
        @original_data.properties.each do |name, property|
          if property.id == property_id then
            return property
          end
        end
      end
    end
  end
end