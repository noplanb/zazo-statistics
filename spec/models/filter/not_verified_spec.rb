require 'rails_helper'

RSpec.describe Filter::NotVerified, type: :model do
  let(:instance) { described_class.new }

  let!(:conn) { FactoryGirl.create :connection }

  describe '#generate' do
    subject { instance.execute }

    specify do
      result = {
        'mkey'      => conn.target.mkey,
        'time_zero' => conn.created_at.to_s,
        'invitee'   => conn.target.name,
        'inviter'   => conn.creator.name
      }
      is_expected.to include(result)
    end
  end
end
