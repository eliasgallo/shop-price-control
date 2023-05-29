class ShoppingSerializer < ApplicationSerializer
  def as_json
    {
      id: id,
      checked: checked,
      name: name,
      offer: offer,
      price: price,
      price_unit: price_unit,
      quantity_value: quantity,
      quantity_type: quantity_type,
      store: store,
      updated_at: format_date(updated_at),
      created_at: format_date(created_at)
    }
  end

  private

  def format_date(date)
    date.strftime('%Y-%m-%d %H:%M:%S')
  end
end