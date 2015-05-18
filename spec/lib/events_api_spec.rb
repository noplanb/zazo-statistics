require 'rails_helper'

RSpec.describe EventsApi do
  let(:instance) { described_class.new }

  describe '#api_base_url' do
    subject { instance.api_base_url }
    it { is_expected.to eq(Figaro.env.events_api_base_url) }
  end

  describe '#connection' do
    subject { instance.connection }
    it { is_expected.to be_a(Faraday::Connection) }
  end

  describe '#messages_sent_path' do
    subject { instance.messages_sent_path }
    it { is_expected.to eq('api/v1/engagement/messages_sent') }
  end

  describe '#messages_sent' do
    let(:options) {}
    subject { instance.messages_sent(options) }

    context 'group by day' do
      let(:options) { { group_by: :day } }
      specify do
        VCR.use_cassette('events_messages_sent_by_day', erb: {
                           base_url: Figaro.env.events_api_base_url
                         }) do
          is_expected.to eq(
            '2015-05-09 00:00:00 UTC' => 3,
            '2015-05-10 00:00:00 UTC' => 4,
            '2015-05-11 00:00:00 UTC' => 5,
            '2015-05-12 00:00:00 UTC' => 5)
        end
      end
    end

    context 'group by week' do
      let(:options) { { group_by: :week } }
      specify do
        VCR.use_cassette('events_messages_sent_by_week', erb: {
                           base_url: Figaro.env.events_api_base_url
                         }) do
          is_expected.to eq(
            '2015-05-03 00:00:00 UTC' => 3,
            '2015-05-10 00:00:00 UTC' => 14)
        end
      end
    end

    context 'group by month' do
      let(:options) { { group_by: :month } }
      specify do
        VCR.use_cassette('events_messages_sent_by_month', erb: {
                           base_url: Figaro.env.events_api_base_url
                         }) do
          is_expected.to eq(
            '2015-05-01 00:00:00 UTC' => 17)
        end
      end
    end
  end

  describe '#metric_path' do
    let(:metric) { :messages_sent }
    subject { instance.metric_path(metric) }
    it { is_expected.to eq('api/v1/metrics/messages_sent') }
  end


  describe '#metric_data' do
    subject { instance.metric_data(metric, options) }

    describe 'messages_sent' do
      let(:metric) { :messages_sent }
      let(:options) {}

      context 'group by day' do
        let(:options) { { group_by: :day } }
        specify do
          VCR.use_cassette('metrics_messages_sent_by_day', erb: {
                             base_url: Figaro.env.events_api_base_url
                           }) do
            is_expected.to eq(
              '2015-05-09 00:00:00 UTC' => 3,
              '2015-05-10 00:00:00 UTC' => 4,
              '2015-05-11 00:00:00 UTC' => 5,
              '2015-05-12 00:00:00 UTC' => 5)
          end
        end
      end

      context 'group by week' do
        let(:options) { { group_by: :week } }
        specify do
          VCR.use_cassette('metrics_messages_sent_by_week', erb: {
                             base_url: Figaro.env.events_api_base_url
                           }) do
            is_expected.to eq(
              '2015-05-04 00:00:00 UTC' => 7,
              '2015-05-11 00:00:00 UTC' => 10)
          end
        end
      end

      context 'group by month' do
        let(:options) { { group_by: :month } }
        specify do
          VCR.use_cassette('metrics_messages_sent_by_month', erb: {
                             base_url: Figaro.env.events_api_base_url
                           }) do
            is_expected.to eq(
              '2015-05-01 00:00:00 UTC' => 17)
          end
        end
      end
    end
  end
end
