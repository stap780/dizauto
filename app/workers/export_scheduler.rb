require "sidekiq-scheduler"

class ExportScheduler
  # проверяем указано ли время в экспорте,
  # если указано и равно текущему времени, то вызываем метод

  include Sidekiq::Worker

  def perform
    exports = Export.where.not(time: nil)
    exports.each do |export|
      ExportJob.perform_later(export, User.first.id) if export.time.present? && export.time.to_i == Time.now.strftime("%H").to_i
      # ExportCreator.call(export) if export.time.present? && export.time.to_i == Time.now.strftime("%H").to_i
    end
  end

end
