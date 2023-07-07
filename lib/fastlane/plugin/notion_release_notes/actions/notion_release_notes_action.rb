require 'fastlane/action'
require_relative '../helper/notion_release_notes_helper'
require_relative '../model/item'
require_relative '../model/property'
require_relative '../model/task'

module Fastlane
  module Actions
    class NotionReleaseNotesAction < Action
      require 'notion'
      require 'json'

      @@client = nil

      def self.run(params)
        Notion.configure do |config|
          config.token = params[:api_token]
        end
        @@client = Notion::Client.new

        version = get_version_details params

        tasks = []
        @@client.database_query(
          database_id: params[:tasks_database],
          filter: {
            'or': [
              {
                'property': params[:tasks_version_prop_name],
                'relation': {
                  'contains': version.id
                }
              }
            ]
          }
        ) do |result|
          tasks.concat(result.results)
        end
        tasks = tasks.map { |t| Task.new t }

        lines = tasks.map { |t| t.format_line+"\n\n" }

        lines.reduce "", :+
      end

      def self.get_version_details(params)
        all_versions = []
        @@client.database_query(database_id: params[:versions_database]) do |page|
          all_versions.concat(page.results)
        end
        all_versions = all_versions.map { |r| Item.new(r) }
        version = {}
        all_versions.each do |ver|
          if (ver.title.title == params[:version]) then
            version = ver
          end
        end

        version
      end

      def self.description
        "Fetches tasks from notion database and assembles release notes in markdown format. This actions needs a integration with read permissions in your workspace and you need to add it to the versions database and issues database"
      end

      def self.authors
        ["Gustavo Fernandes"]
      end

      def self.return_value
        "String containing the release notes from notion"
      end

      def self.details
        # Optional:
        "Fetches tasks from notion database and assembles release notes in markdown format"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :api_token,
            env_name: "FL_NOTION_RELEASE_NOTES_API_TOKEN",
            description: "Integration API Token",
          ),
          FastlaneCore::ConfigItem.new(
            key: :versions_database,
            env_name: "FL_NOTION_RELEASE_NOTES_VERSIONS_DATABASE",
            description: "Versions database ID",
          ),
          FastlaneCore::ConfigItem.new(
            key: :tasks_database,
            env_name: "FL_NOTION_RELEASE_NOTES_TASKS_DATABASE",
            description: "Tasks database ID",
          ),
          FastlaneCore::ConfigItem.new(
            key: :version,
            env_name: "FL_NOTION_RELEASE_NOTES_VERSION",
            description: "Name of the target version",
          ),
          FastlaneCore::ConfigItem.new(
            key: :tasks_version_prop_name,
            env_name: "FL_NOTION_RELEASE_NOTES_TASKS_RELATION_PROP_NAME",
            description: "Name of the relation property on the tasks database that relates to the versions database",
          ),
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
