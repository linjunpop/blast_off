require 'blast_off/project'

describe BlastOff::Project do
  let(:project) { BlastOff::Project.new(app_name: 'Grid Diary', scheme: 'Beta') }
  subject { project }

  describe "#initialize" do
    its(:app_name) { should eq 'Grid Diary' }
    its(:scheme) { should eq 'Beta' }
  end
end

