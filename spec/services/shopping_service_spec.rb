require 'rails_helper'

describe ShoppingService do
  describe '#new_item' do
    it 'creates item' do
      user = User.create(username: 'any')
      expect(ShoppingItem.count).to be(0)
      described_class.new(user, {}).new_item
      expect(ShoppingItem.count).to be(1)
    end
  end

  describe '#delete_items' do
    it 'deletes item' do
      user = User.create(username: 'user')
      item = ShoppingItem.create(user: user)
      item_2 = ShoppingItem.create(user: user)
      item_3 = ShoppingItem.create(user: User.create(username: 'other user'))
      expect(ShoppingItem.count).to be(3)
      described_class.new(user, { ids: [item.id, item_2.id, item_3.id] }).delete_items
      expect(ShoppingItem.count).to be(1)
    end
  end
end
