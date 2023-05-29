require 'rails_helper'

describe PriceControlService do
  describe '#new_item' do
    it 'creates item' do
      user = User.create(username: 'any')
      expect(PriceOfferItem.count).to be(0)
      described_class.new(user, {}).new_item
      expect(PriceOfferItem.count).to be(1)
    end
  end

  describe '#delete_item' do
    it 'deletes item' do
      user = User.create(username: 'user')
      item = PriceOfferItem.create(user: user)
      item_2 = PriceOfferItem.create(user: user)
      item_3 = PriceOfferItem.create(user: User.create(username: 'other user'))
      expect(PriceOfferItem.count).to be(3)
      described_class.new(user, { ids: [item.id, item_2.id, item_3.id] }).delete_items
      expect(PriceOfferItem.count).to be(1)
    end
  end
end
