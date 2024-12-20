class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :companies

  # before_create :set_user_role

  attribute :role, :string, default: 'admin'

  ROLES = %w{super_admin admin manager editor collaborator}

  def jwt_payload
    super
  end

  ROLES.each do |role_name|
    define_method "#{role_name}?" do
      role == role_name
    end
  end

  # def set_user_role
  #   self.role = 'admin'
  # end

  # def super_admin?
  #   role == 'super_admin'
  # end

  # def admin?
  #   role == 'admin'
  # end

  # def manager?
  #   role == 'manager'
  # end
end
