require 'rails_helper'

RSpec.describe Repository, type: :model do
  describe 'validation' do
    subject { create(:repository) }

    describe '#name' do
      it { is_expected.to validate_presence_of :name }
    end

    describe '#full_name' do
      it { is_expected.to validate_presence_of :full_name }
    end

    describe 'belongs_to :user' do
      it { is_expected.to belong_to :user }
    end
  end
end
