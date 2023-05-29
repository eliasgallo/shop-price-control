class User < ApplicationRecord
  validates :username, length: { in: 2..20 }, on: :create
  validates :username, presence: { error_code: :presence }
  validates :username, uniqueness: { error_code: :uniqueness, case_sensitive: false },
                       format: { with: /\A[a-z0-9][a-z0-9_]*\z/i, error_code: :format }

  before_save :downcase_username

  has_many :shopping_items
  has_many :price_offer_items
  has_many :sessions

  def downcase_username
    username.downcase!
  end

  def current_session
    sessions.active.first
  end
end