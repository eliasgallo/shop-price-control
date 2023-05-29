require 'rails_helper'

describe Authentication do
  describe '#perform' do
    let(:ip_address) { '127.0.0.1' }

    context 'when no sessions exists' do
      it 'should create and return a session' do
        user = User.create(username: 'anything')
        expect(user.current_session).to be_nil
        result = described_class.new(user, ip_address: ip_address).perform
        expect(user.current_session).to match(result)
      end
    end

    context 'when all sessions are expired' do
      it 'should create and return a session' do
        user = User.create(username: 'anything')
        Session.create(user: user, updated_at: 2.days.ago)
        Session.create(user: user, updated_at: 3.days.ago)
        expect(user.current_session).to be_nil
        expect(user.sessions.count).to eq(2)
        result = described_class.new(user, ip_address: ip_address).perform
        expect(user.current_session).to match(result)
        expect(user.sessions.count).to be(3)
      end
    end

    context 'when an active session exists' do
      it 'should touch updated_at and return the session' do
        user = User.create(username: 'anything')
        session = Session.create(user: user, token: 'a-token')
        expect(user.sessions.count).to be(1)
        result = described_class.new(user).perform
        expect(result).to match(session)
        expect(user.sessions.count).to be(1)
        expect(Session.count).to be(1)
      end
    end
  end
end
