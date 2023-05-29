require 'rails_helper'

describe User do
  subject(:user) { described_class.new(username: username) }
  let(:username) { 'User123' }

  describe '#username' do
    context 'is too short' do
      let(:username) { 's' }
      it { is_expected.to_not be_valid }
    end

    context 'is too long' do
      let(:username) { 's' * 21 }
      it { is_expected.to_not be_valid }
    end

    context 'is not present' do
      let(:username) { nil }
      it { is_expected.to_not be_valid }
    end

    context 'is downcased' do
      before { user.save! }
      it { expect(user[:username]).to eq(username.downcase) }
    end
  end

  describe '#current_session' do
    context 'when user has no sessions at all' do
      it { expect(user.current_session).to be_nil }
    end

    context 'when user has no active sessions' do
      before do
        Session.create(updated_at: 2.days.ago, token: 'abc123', user: user)
      end
      it { expect(user.current_session).to be_nil }
    end

    context 'when user has many sessions' do
      before do
        Session.create!(token: 'three', updated_at: 3.days.ago, user: user)
        Session.create!(token: 'two', updated_at: 2.days.ago, user: user)
        Session.create!(token: 'one', updated_at: 1.day.ago, user: user)
        Session.create!(token: 'zero', updated_at: 1.minute.ago, user: user)
      end

      it { expect(user.current_session.token).to eq('zero') }
    end
  end
end