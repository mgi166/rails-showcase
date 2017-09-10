require 'rails_helper'

RSpec.describe Repository, type: :model do
  describe 'validation' do
    subject { create(:repository) }

    describe '#name' do
      it { is_expected.to validate_presence_of :name }
    end

    describe '#name_with_owner' do
      it { is_expected.to validate_presence_of :name_with_owner }
    end

    describe 'belongs_to :user' do
      it { is_expected.to belong_to :user }
    end
  end

  describe '.index' do
    subject { Repository.index(params).to_a }

    let!(:repo_1) { create(:repository, name_with_owner: 'abc/def', stargazers_count: 1, forks_count: 4, pushed_at: 1.second.ago) }
    let!(:repo_2) { create(:repository, name_with_owner: 'xyz/xyz', stargazers_count: 3, forks_count: 2, pushed_at: 3.second.ago) }
    let!(:repo_3) { create(:repository, name_with_owner: 'bcd/abc', stargazers_count: 2, forks_count: 1, pushed_at: 4.second.ago) }
    let!(:repo_4) { create(:repository, name_with_owner: 'efg/hij', stargazers_count: 4, forks_count: 3, pushed_at: 2.second.ago) }

    context 'with no params' do
      let(:params) { {} }

      it 'returns all repositories' do
        expected_repos =  [
          repo_4,
          repo_3,
          repo_2,
          repo_1,
        ]
        is_expected.to eq expected_repos
      end
    end

    context 'with `repo_or_username`' do
      let(:params) { { repo_or_username: 'abc' } }

      it 'returns repositories with name_with_owner' do
        expected_repos =  [
          repo_3,
          repo_1,
        ]
        is_expected.to eq expected_repos
      end
    end

    context 'with `order`' do
      context 'stargazers_count' do
        let(:params) { { order: 'stargazers_count' } }

        it 'returns repositories order by stargazers_count' do
          expected_repos =  [
            repo_4,
            repo_2,
            repo_3,
            repo_1,
          ]
          is_expected.to eq expected_repos
        end
      end

      context 'forked_count' do
        let(:params) { { order: 'forks_count' } }

        it 'returns repositories order by forked_count' do
          expected_repos =  [
            repo_1,
            repo_4,
            repo_2,
            repo_3,
          ]
          is_expected.to eq expected_repos
        end
      end

      context 'pushed_at' do
        let(:params) { { order: 'pushed_at' } }

        it 'returns repositories order by pushed_at' do
          expected_repos =  [
            repo_1,
            repo_4,
            repo_2,
            repo_3,
          ]
          is_expected.to eq expected_repos
        end
      end
    end
  end
end
