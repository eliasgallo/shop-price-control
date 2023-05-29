class ShoppingService
  def initialize(user, params)
    @user = user
    @params = params
  end

  def new_item
    ShoppingItem.create(
      checked: params[:checked] || false,
      name: params[:name],
      offer: params[:offer] || false,
      price: params[:price],
      price_unit: params[:priceUnit],
      quantity: params[:quantityValue],
      quantity_type: params[:quantityType],
      store: params[:store],
      user: user
    )
  end

  def update_item
    item = ShoppingItem.find_by(id: params[:id], user: user)
    return if item.nil?
    item.update!(
      checked: checked(item),
      name: params[:name] || item[:name],
      offer: offer(item),
      price: params[:price] || item[:price],
      price_unit: params[:priceUnit] || item[:price_unit],
      quantity: params[:quantityValue] || item[:quantity_value],
      quantity_type: params[:quantityType] || item[:quantity_type],
      store: params[:store] || item[:store]
    )
    item
  end

  def delete_items
    ShoppingItem.where(id: params[:ids], user: user).destroy_all
  end

  def delete_all_items
    user.shopping_items.destroy_all
  end

  def delete_checked_items
    ShoppingItem.where(user: user, checked: true).destroy_all
  end

  private
  attr_reader :user, :params

  def checked(item)
    return false if params[:checked] == false
    return true if params[:checked]
    item[:checked]
  end

  def offer(item)
    return false if params[:offer] == false
    return true if params[:offer]
    item[:offer]
  end
end
