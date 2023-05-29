class CreatePriceControlData
  def perform
    current_category = ''
    File.open('app/services/pricecontroldata', 'r') do |f|
      f.each_line do |line| 
        split = line.strip.split('|')
        if split.count == 1
          current_category = split.first.downcase
        elsif split.count == 3
          price_unit_and_reliability = price_unit_and_reliability(split.last.downcase)
          name = split.first
          PriceOfferItem.create!(
            user: User.first,
            name: name,
            category: current_category,
            comparison_price: split.second.to_f,
            comparison_price_unit: price_unit_and_reliability.first,
            reliability: price_unit_and_reliability.second,
            tags: tags(name.downcase, current_category)
          )
        else
          p "ERROR. Could not read: '#{line}'" if line != '\n'
        end
      end
    end
  end

  private

  def price_unit_and_reliability(string)
    if string.last == '?'
      string = string.chop
      reliability = PriceOfferItem::UNSURE
    elsif string.last == '!'
      string = string.chop
      reliability = PriceOfferItem::SURE
    else
      reliability = PriceOfferItem::OLD
    end

    price_unit = ''
    if string == 'kg'
      price_unit = PriceOfferItem::KR_KG
    elsif string == 'l'
      price_unit = PriceOfferItem::KR_L
    elsif string == 'st'
      price_unit = PriceOfferItem::KR_UNIT
    elsif string == 'tvätt'
      price_unit = PriceOfferItem::KR_ACTION
    else
      raise "can not read price unit: #{price_unit}"
    end

    return [price_unit, reliability]
  end

  def tags(name, category = nil)
    tags = []
    tags << PriceOfferItem::SWEDISH if name.include?('svensk') || category == 'animalistic'
    tags << PriceOfferItem::EKOLOGICAL if name.include?('eko')
    tags << PriceOfferItem::FROZEN if name.include?('frys')
    tags
  end
end
