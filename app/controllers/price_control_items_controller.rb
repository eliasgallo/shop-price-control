class PriceControlItemsController < ApplicationController
  before_action :verify_user
  before_action :ensure_ids_exist, only: :destroy

  # curl -X POST localhost:3000/price_control_items -H "Content-Type: application/json" -H "Authorization: AUTH" -d '{"name": "item_1"}'
  def create
    p 'CREATE', params
    item = PriceControlService.new(current_user, params).new_item
    render json: PriceControlSerializer.new(item).as_json, status: 200
  end

  # curl -X PUT localhost:3000/price_control_items -H "Content-Type: application/json" -H "Authorization: AUTH" -d '{"id": 275, "name": "item_2"}'
  def update
    p 'UPDATE', params
    item = PriceControlService.new(current_user, params).update_item
    return render json: PriceControlSerializer.new(item).as_json, status: 200 if item
    render_response(:bad_request, 'no item found')
  end

  # curl -X GET localhost:3000/price_control_items -H "Content-Type: application/json" -H "Authorization: AUTH"
  def show
    p 'SHOW'
    serializer_json_items(current_user.price_offer_items)
  end

  # curl -X DELETE localhost:3000/price_control_items -H "Content-Type: application/json" -H "Authorization: AUTH" -d '{"ids":[1]}'
  def destroy
    p 'DESTROY', params[:ids]
    items = PriceControlService.new(current_user, params).delete_items
    serializer_json_items(items)
  end

  def delete_all
    p 'DESTROY ALL'
    items = PriceControlService.new(current_user, params).delete_all_items
    serializer_json_items(items)
  end

  private
  attr_reader :user, :session

  def verify_user
    render_response(:auth_failed) if current_user.nil?
  end

  def ensure_ids_exist
    return render_response(:bad_request, 'ids array is mandatory') if params[:ids].blank?
    render_response(:bad_request, 'ids has to be an array') unless params[:ids].is_a?(Array)
  end

  def serializer_json_items(items)
    render json: items.map { |i| PriceControlSerializer.new(i).as_json }, status: 200
  end
end