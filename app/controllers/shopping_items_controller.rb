class ShoppingItemsController < ApplicationController
  before_action :verify_user
  before_action :ensure_ids_exist, only: :destroy

  # curl -X POST localhost:3000/shopping_items -H "Content-Type: application/json" -H "Authorization: AUTH" -d '{"name": "item_1"}'
  def create
    p 'CREATE', params
    item = ShoppingService.new(current_user, params).new_item
    return render json: ShoppingSerializer.new(item).as_json, status: 200 if item
    render_response(:bad_request, 'Could not create item')
  end

  # curl -X PUT localhost:3000/shopping_items -H "Content-Type: application/json" -H "Authorization: AUTH" -d '{"id": 1, "name": "item_2"}'
  def update
    p 'UPDATE', params
    item = ShoppingService.new(current_user, params).update_item
    return render json: ShoppingSerializer.new(item).as_json, status: 200 if item
    render_response(:bad_request, 'No item found')
  end

  # curl -X GET localhost:3000/shopping_items -H "Content-Type: application/json" -H "Authorization: AUTH"
  def show
    p 'SHOW'
    serializer_json_items(current_user.shopping_items)
  end

  # curl -X DELETE localhost:3000/shopping_items -H "Content-Type: application/json" -H "Authorization: AUTH" -d '{"ids":[1]}'
  def destroy
    p 'DESTROY', params[:ids]
    items = ShoppingService.new(current_user, params).delete_items
    return serializer_json_items(items) if items.present?
    return render json: 'Items already deleted', status: 202
    render_response(:bad_request, 'No items found')
  end

  def delete_all
    p 'DESTROY ALL'
    items = ShoppingService.new(current_user, params).delete_all_items
    return serializer_json_items(items) if items
    return render json: 'Items already deleted', status: 202
    render_response(:bad_request, 'No items found')
  end

  def delete_checked_items
    p 'DESTROY checked ALL'
    items = ShoppingService.new(current_user, params).delete_checked_items
    return serializer_json_items(items) if items
    return render json: 'Items already deleted', status: 202
    render_response(:bad_request, 'No items found')
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
    render json: items.map { |i| ShoppingSerializer.new(i).as_json }, status: 200
  end
end
