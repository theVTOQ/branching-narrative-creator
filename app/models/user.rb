class User < ApplicationRecord
    has_secure_password
    has_many :narratives
    has_many :documents, through: :narratives
    #validates :name, presence: true, length: {minimum: 2}, unless: ->(x) { x.name.blank? }
    validates :name, length: {minimum: 2}, unless: ->(x) { x.name.blank? }
    validates :email, presence: true, uniqueness: true
end