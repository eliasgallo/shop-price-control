class PriceOfferItem < ApplicationRecord
  belongs_to :user

  CATEGORY_TYPES = [KR_KG = 'krKg', KR_L = 'krL', KR_UNIT = 'krUnit', KR_ACTION = 'krAction']
  RELIABILITY_TYPES = [UNSURE = 'unsure', SURE = 'sure', OLD = 'old']
  TAGS_TYPES = [FROZEN = 'frozen', EKOLOGICAL = 'ekological', SWEDISH = 'swe']
end
