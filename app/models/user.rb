# File for User model
class User < ApplicationRecord
  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end
  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications

  has_many :cards, dependent: :destroy
  has_many :decks, dependent: :destroy

  before_save :downcase_email

  validates :password, length: { minimum: 6 },
                       if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true,
                       if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true,
                       if: -> { new_record? || changes[:crypted_password] }
  validates :email, uniqueness: true

  def downcase_email
    self.email = email.downcase
  end

  belongs_to :current_deck, class_name: Deck, foreign_key: 'current_deck_id'

  scope :with_cards_for_review, -> { joins(:cards).where('review_date <= ?', Time.now) }

  def self.cards_notification_email
    with_cards_for_review.each do |user|
      NotificationsMailer.pending_cards(user).deliver_now
    end
  end
end
