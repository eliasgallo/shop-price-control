require 'rails_helper'

describe PriceControlItemsController do
  let(:params) {}

  before do
    user = User.create!(username: 'testuser')
    session = Session.create(user: user, token: 'token123')
    request.headers['HTTP_AUTHORIZATION'] = session.token
  end

  describe 'GET #show' do
    def show_item_request
      get :show, params: params
    end

    before do
      PriceOfferItem.create(user: User.first, name: 'item_1')
      user_2 = User.create(username: 'testuser_2')
      PriceOfferItem.create(user: user_2, name: 'item_2')
    end

    context 'for an User' do
      it 'will return only items for that user' do
        expect(PriceOfferItem.count).to eq(2)
        show_item_request
        expect(response.code).to eq('200')
        expect(json_response.length).to eq(1)
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
        expect(json_response['name']).to eq(item_name)
      end

      it 'and creates two items' do
        expect(PriceOfferItem.count).to eq(0)
        create_item_request
        create_item_request
        expect(response.code).to eq('200')
        expect(PriceOfferItem.count).to eq(2)
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
      PriceOfferItem.create(user: User.first)
      PriceOfferItem.create(user: User.first)
      PriceOfferItem.create(user: User.first)
    end

    context 'with an unknown item' do
      let(:params) { { id: 0 } }

      it 'will not change anything and just return the items' do
        item_updated_at = PriceOfferItem.last.updated_at
        update_item_request
        expect(PriceOfferItem.last.reload.updated_at).to match(item_updated_at)
        status = ApiControllerResponseStatus::STATUSES[:bad_request]
        expect(response.code).to eq(status[:code].to_s)
        expect(json_response['message']).to eq('no item found')
      end
    end

    context 'with a known item' do
      let(:params) { { id: PriceOfferItem.last.id, name: 'item_1' } }

      it 'will change only that item and return all items' do
        item_1_updated_at = PriceOfferItem.first.updated_at
        item_2_updated_at = PriceOfferItem.second.updated_at
        item_3_updated_at = PriceOfferItem.last.updated_at
        update_item_request
        expect(response.code).to eq('200')
        expect(PriceOfferItem.first.reload.updated_at).to match(item_1_updated_at)
        expect(PriceOfferItem.second.reload.updated_at).to match(item_2_updated_at)
        expect(PriceOfferItem.last.reload.updated_at).to_not match(item_3_updated_at)
      end
    end

    context 'the name of an item' do
      let(:params) { { id: 9999, name: 'change_name' } }

      it 'will not change anything and just return the items' do
        PriceOfferItem.create(user: User.first, id: params[:id])
        update_item_request
        expect(response.code).to eq('200')
        expect(PriceOfferItem.last.name).to match(params[:name])
      end
    end
  end

  describe 'DELETE #destroy' do
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
        ids.each { |i| PriceOfferItem.create(user: User.first, id: i) }
        PriceOfferItem.create(user: User.first, name: 'item_4')
      end

      it 'destroys items using params[:ids]' do
        expect(PriceOfferItem.count).to eq(4)
        destroy_item_request
        expect(response.code).to eq('200')
        expect(json_response.length).to eq(3)
        expect(PriceOfferItem.count).to eq(1)
        expect(PriceOfferItem.first[:name]).to eq('item_4')
      end
    end
  end

  describe 'DELETE #delete_all' do
    def destroy_item_request
      delete :delete_all
    end

    before do
      PriceOfferItem.create(user: User.first)
      PriceOfferItem.create(user: User.first)
      PriceOfferItem.create(user: User.first)
      PriceOfferItem.create(user: User.create(username: 'testuser_2'), name: 'item_4')
    end

    it 'destroys items for logged in user' do
      expect(PriceOfferItem.count).to eq(4)
      destroy_item_request
      expect(response.code).to eq('200')
      expect(PriceOfferItem.count).to eq(1)
      expect(PriceOfferItem.first[:name]).to eq('item_4')
    end
  end
end
