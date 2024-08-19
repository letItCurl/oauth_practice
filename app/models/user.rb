class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable , omniauth_providers: [ :google_oauth2 ]

  def self.from_omniauth(auth)
    existing_user = self.find_by(email: auth.info.email)

    if existing_user.nil?
      self.create(
        email: auth.info.email,
        provider: auth.provider,
        google_uid: auth.uid,
        password: Devise.friendly_token[0, 20]
      )
    else
      existing_user.update(provider: auth.provider, google_uid: auth.uid)
    end
  end
end
