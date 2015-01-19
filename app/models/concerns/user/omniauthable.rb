class User
  module Omniauthable
    extend ActiveSupport::Concern
    
    module ClassMethods
      def from_omniauth(auth)
        user = User.where(provider: auth.provider, uid: auth.uid).first
        
        unless user
          user = User.new
          user.provider = auth.provider
          user.uid = auth.uid
          user.first_name = auth.info.first_name
          user.last_name = auth.info.last_name 
          user.email = auth.info.email
          user.lastfm_user_name = auth.info.nickname if user.provider == 'lastfm'
          user.save
        end
        
        user
      end
      
      def new_with_session(params, session)
        if session["devise.user_attributes"]
          new(session["devise.user_attributes"], without_protection: true) do |user|
            user.attributes = params
            user.valid?
          end
        else
          super
        end
      end
    end
  end
    
  def password_required?
    super && provider.blank?
  end

  def email_required?
    super && provider.blank?
  end
  
  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end
end