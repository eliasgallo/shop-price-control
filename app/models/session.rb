class Session < ApplicationRecord
  SESSION_EXPIRE = 30.minutes

  belongs_to :user

  scope :active, -> { where('updated_at > ?', SESSION_EXPIRE.ago) }

  # .sort_by(&:updated_at).reverse

  # def is_expired?
  #   updated_at < SESSION_EXPIRE.ago
  # end
end