module Fastlane
  module Actions
    class Property
      String @name
      Hash @original_data
      String @type
      String @id

      attr_reader :name
      attr_reader :original_data
      attr_reader :type
      attr_reader :id

      JSON_DATA_SIZE = 3

      def initialize(original_data, name = nil)
        @original_data = original_data
        @name = name
        @type = original_data.type
        @id = original_data.id
      end

      def self.create(original_data, name = nil)
        case original_data.type
        when "title"
          return Title.new original_data, name
        when "relation"
          return Relation.new original_data, name
        when "unique_id"
          return UniqueId.new original_data, name
        else
          return Property.new original_data, name
        end
      end

      def to_json(params = {})
        {
          "name" => @name,
          "type" => @type,
          "id" => @id,
          "original_data" => (@original_data if params[:show_original_data])
        }.compact
      end

      def to_s
        "#{to_json}"
      end
    end

    class Title < Property
      String @title

      attr_reader :title

      def initialize(original_data, name = nil)
        super
        @title = original_data.title[0].plain_text
      end

      def to_json(params = {})
        Hash[ super(params).to_a.insert(JSON_DATA_SIZE, ['title', @title]) ]
      end

      def to_s
        @title
      end
    end

    class Relation < Property
      @relation

      attr_reader :relation

      def initialize(original_data, name = nil)
        super
        if (original_data.relation.kind_of?(Array)) then
          @relation = original_data.relation.map { |r| r.id }
        elsif (original_data.relation.kind_of?(Hash)) then
          @relation = original_data.relation.id
        end
      end

      def to_json(params = {})
        Hash[ super(params).to_a.insert(JSON_DATA_SIZE, ['relation', @relation]) ]
      end
    end

    class UniqueId < Property
      String @prefix = nil
      @number = nil

      attr_reader :prefix
      attr_reader :number

      def initialize(original_data, name = nil)
        super
        @prefix = original_data.unique_id.prefix
        @number = original_data.unique_id.number
      end

      def to_s
        "#@prefix-#@number"
      end

      def to_json(params = {})
        Hash[ 
          super(params)
            .to_a
            .insert(JSON_DATA_SIZE, ['prefix', @prefix])
            .insert(JSON_DATA_SIZE+1, ['title', @title])
            .insert(JSON_DATA_SIZE+2, ['as_string', to_s])
          ]
      end
    end
  end
end