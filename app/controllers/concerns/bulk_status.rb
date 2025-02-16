# This module provides functionality for bulk status change records in a application.
module BulkStatus
  extend ActiveSupport::Concern

  def bulk_status
    if params[items].present?
      @collection_ids = model.where(id: params[items]).pluck(:id)
      @model = model
      @status_model = status_model
      @hidden_field = hidden_field
      @update_field = update_field
      render template: 'shared/bulk_status'
    else
      flash.now[:notice] = 'Выберите позиции'
      render turbo_stream: [
        render_turbo_flash
      ]
    end
  end

  def bulk_status_update
    model.where(id: params[items]).each do |record|
      record.update({update_field => params[update_field]})
    end
    flash.now[:success] = 'Обновили статус'
    render turbo_stream: [
      render_turbo_flash
    ]
  end

  protected

  def items
    "#{controller_name.singularize}_ids".to_sym
  end

  def model
    controller_name.singularize.camelize.constantize
  end

  def status_model
    "#{model}_status".singularize.camelize.constantize
  end

  def hidden_field
    "#{model.to_s.underscore}_ids[]".to_sym
  end

  def update_field
    "#{model.to_s.underscore}_status_id".to_sym
  end


end