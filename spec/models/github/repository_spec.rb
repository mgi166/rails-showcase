require 'rails_helper'

RSpec.describe Github::Repository, type: :model do
  describe '#create!' do
    subject { repository.create!(user) }

    let(:user) { create(:user) }

    context 'given no attributes' do
      let(:repository) { Github::Repository.new('user/repo') }

      it 'creates Repository model' do
        expect { subject }.to change(Repository, :count).by(1)
      end

      it { is_expected.to be_instance_of Repository }

      it 'create Repository instance with expected attributes' do
        expect(subject.name).to eq "repo"
        expect(subject.html_url).to eq nil
        expect(subject.stargazers_count).to eq nil
        expect(subject.forks_count).to eq nil
      end
    end

    context 'given attributes' do
      let(:repository) { Github::Repository.new('user/repo', description: "test", html_url: "http://github.com", stargazers_count: 1, forks_count: 2) }

      it 'creates Repository model' do
        expect { subject }.to change(Repository, :count).by(1)
      end

      it { is_expected.to be_instance_of Repository }

      it 'create Repository instance with expected attributes' do
        expect(subject.name).to eq "repo"
        expect(subject.html_url).to eq 'http://github.com'
        expect(subject.stargazers_count).to eq 1
        expect(subject.forks_count).to eq 2
      end
    end
  end

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
