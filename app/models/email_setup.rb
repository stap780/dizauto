class EmailSetup < ApplicationRecord

    def self.ransackable_attributes(auth_object = nil)
        EmailSetup.attribute_names
    end
  
    def has_smtp_settings?
      self.smtp_settings.present?
    end
    
    def smtp_settings
      smtp = EmailSetup.first
      if smtp
        smtp_settings = {
          tls: smtp.tls,
          enable_starttls_auto: true,
          openssl_verify_mode: "none",
          address: smtp.address,
          port: smtp.port,
          domain: smtp.domain,
          authentication: smtp.authentication,
          user_name: smtp.user_name,
          password: smtp.user_password.to_s
          }
      end
    end
  
end
