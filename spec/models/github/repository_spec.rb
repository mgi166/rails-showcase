require 'rails_helper'

RSpec.describe Github::Repository, type: :model do
  describe '#rails?' do
    subject { repository.rails? }
    let(:repository) { Github::Repository.new('user/repo') }



    context 'when repository is rails application' do
      before { allow(repository).to receive(:gemfile_contents).and_return("gem 'rails'") }
      it { is_expected.to be true }
    end

    context 'when repository is not rails application' do
      context '`Gemfile` does not exist in repository' do
        before { allow(repository).to receive(:gemfile_contents).and_raise(Octokit::NotFound) }
        it { is_expected.to be false }
      end

      context '`Gemfile` can not be parsed' do
        before { allow(repository).to receive(:gemfile_contents).and_return('test') }
        it { is_expected.to be false }
     end

      context '`Gemfile` does not include `rails`' do
        before { allow(repository).to receive(:gemfile_contents).and_return('gem "octokit"') }
        it { is_expected.to be false }
      end
    end
  end
end
