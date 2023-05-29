require 'rails_helper'

describe ShoppingItemsController do
  let(:params) {}
  let(:user) { User.create!(username: 'testuser') }

  before do
    session = Session.create(user: user, token: 'token123')
    request.headers['HTTP_AUTHORIZATION'] = session.token
  end

  describe 'GET #show' do
    def show_item_request
      get :show, params: params
    end

    before do
      ShoppingItem.create(user: user, name: 'item_1')
      ShoppingItem.create(user: User.create(username: 'testuser_2'), name: 'item_2')
    end

    context 'for an User' do
      it 'will return only items for that user' do
        expect(ShoppingItem.count).to eq(2)
        show_item_request
        expect(json_response.length).to be(1)
        expect(json_response.first['name']).to match('item_1')
      end
    end
  end

  describe 'POST #create' do
    def create_item_request
      post :create, params: params
    end

    context 'and user was found' do
      let(:item_name) { 'item_1' }
      let(:params) { { name: item_name } }

      it 'and creates item' do
        create_item_request
        expect(response.code).to eq('200')
        expect(user.shopping_items.count).to eq(1)
        expect(json_response['name']).to eq(item_name)
      end

      it 'and creates two items' do
        create_item_request
        create_item_request
        expect(response.code).to eq('200')
        expect(user.shopping_items.count).to eq(2)
      end
    end

    context 'and user was not found' do
      before do
        request.headers['HTTP_AUTHORIZATION'] = 'unknown_token'
      end
      it 'returns auth_failed' do
        post :create, params: params
        status = ApiControllerResponseStatus::STATUSES[:auth_failed]
        expect(response.code).to eq(status[:code].to_s)
        expect(json_response['message']).to eq(status[:msg])
      end
    end
  end

  describe 'PUT #update' do
    def update_item_request
      put :update, params: params
    end

    before do
      ShoppingItem.create(user: user)
      ShoppingItem.create(user: user)
      ShoppingItem.create(user: user)
    end

    context 'with an unknown item' do
      let(:params) { { id: 0 } }

      it 'will not change anything and just return the items' do
        item_updated_at = ShoppingItem.last.updated_at
        update_item_request
        expect(ShoppingItem.last.reload.updated_at).to match(item_updated_at)
      end
    end

    context 'with a known item' do
      let(:params) { { id: ShoppingItem.last.id, name: 'item_1' } }

      it 'will change only that item and return all items' do
        item_1_updated_at = ShoppingItem.first.updated_at
        item_2_updated_at = ShoppingItem.second.updated_at
        item_3_updated_at = ShoppingItem.last.updated_at
        update_item_request
        expect(ShoppingItem.first.reload.updated_at).to match(item_1_updated_at)
        expect(ShoppingItem.second.reload.updated_at).to match(item_2_updated_at)
        expect(ShoppingItem.last.reload.updated_at).to_not match(item_3_updated_at)
      end
    end

    context 'the name of an item' do
      let(:params) { { id: 9999, name: 'change_name' } }

      it 'will not change anything and just return the items' do
        ShoppingItem.create(user: user, id: params[:id])
        update_item_request
        expect(ShoppingItem.last.name).to match(params[:name])
      end
    end
  end

  describe 'POST #destroy' do
    def destroy_item_request
      post :destroy, params: params
    end

    context 'when no ids are included' do
      it 'returns an error' do
        destroy_item_request
        status = ApiControllerResponseStatus::STATUSES[:bad_request]
        expect(response.code).to eq(status[:code].to_s)
        expect(json_response['message']).to eq('ids array is mandatory')
      end
    end

    context 'when ids is not an array' do
      let(:params) {{ ids: 1 }}
      it 'returns an error' do
        destroy_item_request
        status = ApiControllerResponseStatus::STATUSES[:bad_request]
        expect(response.code).to eq(status[:code].to_s)
        expect(json_response['message']).to eq('ids has to be an array')
      end
    end

    context 'when ids array exist' do
      let(:ids) { [10, 11, 15] }
      let(:params) {{ ids: ids }}
      before do
        ids.each { |i| ShoppingItem.create(user: user, id: i) }
        ShoppingItem.create(user: user, name: 'item_4', id: 16)
      end

      it 'destroys items sent via the params' do
        expect(user.shopping_items.count).to be(4)
        destroy_item_request
        expect(user.shopping_items.count).to be(1)
        expect(json_response.length).to be(3)
        expect(user.shopping_items.first[:name]).to eq('item_4')
      end
    end
  end

  describe 'POST #delete_all' do
    before do
      3.times.each { |i| ShoppingItem.create(user: user) }
      other_user = User.create(username: 'testuser_2')
      ShoppingItem.create(user: other_user, name: 'item_4')
    end

    it 'destroys all items for authorised user' do
      expect(user.shopping_items.count).to be(3)
      post :delete_all
      expect(user.shopping_items.count).to be(0)
      expect(ShoppingItem.count).to be(1)
      expect(json_response.length).to be(3)
      expect(ShoppingItem.first[:name]).to eq('item_4')
    end
  end

  describe 'POST #delete_checked_items' do
    before do
      2.times.each { |i| ShoppingItem.create(user: user, checked: true) }
      ShoppingItem.create(user: user)
      other_user = User.create(username: 'testuser_2')
      ShoppingItem.create(user: other_user, name: 'item_4', checked: true)
    end

    it 'destroys all items for authorised user' do
      expect(user.shopping_items.count).to be(3)
      post :delete_checked_items
      expect(user.shopping_items.count).to be(1)
      expect(user.shopping_items.first[:checked]).to be_falsey
      expect(ShoppingItem.count).to be(2)
      expect(json_response.length).to be(2)
    end
  end
end
