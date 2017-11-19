require 'rails_helper'

RSpec.describe RailsShowcase::ExceptionNotifier, type: :lib do
  describe '.notify' do
    subject { RailsShowcase::ExceptionNotifier.notify(exception) }

    context 'with exception backtrace' do
      let(:exception) { Exception.new('message') }

      it 'send exception to sentry and write log to {RAILS_ENV}.log' do
        expect(Raven).to receive(:capture_exception).with(exception)
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

      it 'send exception to sentry and write log to {RAILS_ENV}.log' do
        expect(Raven).to receive(:capture_exception).with(exception)
        expect(Rails.logger).to receive(:error).with("[Exception] message")
        expect(Rails.logger).to receive(:error).with("one\ntwo\nthree")

        subject
      end
    end
  end
end
