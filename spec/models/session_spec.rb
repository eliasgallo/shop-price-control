require 'rails_helper'

describe Session do
  describe '#active' do
    include ActiveSupport::Testing::TimeHelpers

    before do
      User.create(username: 'any')
    end

    it 'passed expiration time' do
      freeze_time do
        described_class.create(updated_at: Session::SESSION_EXPIRE.ago - 1.minute, user: User.first)
        expect(described_class.active.first).to be_nil
      end
    end

    it 'within expiration time' do
      freeze_time do
        described_class.create!(updated_at: Session::SESSION_EXPIRE.ago + 1.minute, user: User.first)
        expect(described_class.active.first).to_not be_nil
      end
    end
  end
end