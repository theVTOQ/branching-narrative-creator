class User < ApplicationRecord
    has_secure_password
    has_many :narratives, dependent: :destroy
    has_many :documents, through: :narratives
    #validates :name, presence: true, length: {minimum: 2}, unless: ->(x) { x.name.blank? }
    validates :name, length: {minimum: 2}, unless: ->(x) { x.name.blank? }
    validates :email, presence: true, uniqueness: true
    before_validation :ensure_admin_default_value

    private

    def ensure_admin_default_value
        self.admin ||= false
    end
end