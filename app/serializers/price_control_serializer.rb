class PriceControlSerializer < ApplicationSerializer
  def as_json
    {
      id: id,
      name: name,
      comparison_price: comparison_price,
      comparison_price_unit: comparison_price_unit,
      reliability: reliability,
      category: category,
      tags: tags,
      updated_at: format_date(updated_at),
      created_at: format_date(created_at)
    }
  end

  private

  def format_date(date)
    date.strftime('%Y-%m-%d %H:%M:%S')
  end
end