module BulkDelete
  extend ActiveSupport::Concern

  def bulk_delete
    # puts "########### search_params download => #{search_params}"
    if params[:delete_type] == "selected" && !params[items].present?
      flash.now[:error] = "Выберите позиции"
      render turbo_stream: [
        render_turbo_flash
      ]
    else
      ## this is was for test - CreateXlsxJob.perform_later(collection_ids, {model: "Product",current_user_id: current_user.id} )
      BulkDeleteJob.perform_later(delete_collection_ids, {model: model.to_s, current_user_id: current_user.id})
      flash.now[:success] = "Запустили удаление"
      render turbo_stream: [
        render_turbo_flash
      ]
      # render turbo_stream:
      #   turbo_stream.update(
      #     'modal',
      #     template: "shared/pending_bulk"
      #   )
    end
  end

  protected

  def items
    :"#{controller_name.singularize}_ids"
  end

  def model
    controller_name.singularize.camelize.constantize
  end

  def delete_collection_ids
    puts "search_params => #{search_params}"
    if params[:delete_type] == "selected"
      collection_ids = model.with_images.where(id: params[items]).pluck(:id) if model == "Product"
      collection_ids = model.where(id: params[items]).pluck(:id) if model != "Product"
    end
    if params[:delete_type] == "filtered"
      collection_ids = model.with_images.ransack(search_params).result(distinct: true).pluck(:id) if model == "Product"
      collection_ids = model.all.ransack(search_params).result(distinct: true).pluck(:id) if model != "Product"
    end
    if params[:delete_type] == "all"
      collection_ids = model.with_images.pluck(:id) if model == "Product"
      collection_ids = model.all.pluck(:id) if model != "Product"
    end
    collection_ids
  end
end
