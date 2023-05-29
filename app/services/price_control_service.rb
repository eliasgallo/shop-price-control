class PriceControlService
  def initialize(user, params)
    @user = user
    @params = params
  end

  def new_item
    PriceOfferItem.create(
      name: params[:name],
      comparison_price: params[:comparisonPrice],
      comparison_price_unit: params[:comparisonPriceUnit],
      reliability: params[:reliability],
      category: params[:category],
      tags: params[:tags] || [],
      user: user
    )
  end

  def update_item
    item = PriceOfferItem.find_by(id: params[:id], user: user)
    return if item.nil?
    item.update!(
      name: params[:name] || item[:name],
      comparison_price: params[:comparisonPrice] || item[:comparison_price],
      comparison_price_unit: params[:comparisonPriceUnit] || item[:comparison_price_unit],
      reliability: params[:reliability] || item[:reliability],
      category: params[:category] || item[:category],
      tags: params[:tags] || item[:tags]
    )
    item
  end

  def delete_items
    PriceOfferItem.where(id: params[:ids], user: user).destroy_all
  end

  def delete_all_items
    user.price_offer_items.destroy_all
  end

  attr_reader :user, :params
end
