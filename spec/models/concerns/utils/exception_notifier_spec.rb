require 'rails_helper'

RSpec.describe Utils::ExceptionNotifier do
  describe '.notify' do
    subject { Utils::ExceptionNotifier.notify(exception) }

    context 'with exception backtrace' do
      let(:exception) { Exception.new('message') }

      it 'logs to rails log' do
        expect(Rails.logger).to receive(:error).with("[Exception] message")

        subject
      end
    end

    context 'without exception backtrace' do
      let(:exception) do
        Exception.new('message').tap do |ex|
          ex.set_backtrace(['one', 'two', 'three'])
        end
      end

      it 'logs to rails log' do
        expect(Rails.logger).to receive(:error).with("[Exception] message")
        expect(Rails.logger).to receive(:error).with("one\ntwo\nthree")

        subject
      end
    end
  end
end
