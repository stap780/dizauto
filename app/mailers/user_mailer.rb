class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.create_export.subject
  #
  def create_export
    puts "create_export_________"
    puts params
    @greeting = params[:message]

    mail to: params[:recipient].email #"panaet80@gmail.com"
  end
end
