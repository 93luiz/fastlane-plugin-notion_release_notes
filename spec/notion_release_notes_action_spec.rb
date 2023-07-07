describe Fastlane::Actions::NotionReleaseNotesAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The notion_release_notes plugin is working!")

      Fastlane::Actions::NotionReleaseNotesAction.run(nil)
    end
  end
end
