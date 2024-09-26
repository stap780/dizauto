module DownloadExcel
  extend ActiveSupport::Concern

  def download
    # puts "########### search_params download => #{search_params}"
    if params[:download_type] == "selected" && !params[items].present?
      flash.now[:error] = "Выберите позиции"
      render turbo_stream: [
        render_turbo_flash
      ]
    else
      ## this is was for test - CreateXlsxJob.perform_later(collection_ids, {model: "Product",current_user_id: current_user.id} )
      CreateZipXlsxJob.perform_later(excel_collection_ids, {model: model.to_s, current_user_id: current_user.id} )
      render turbo_stream: 
        turbo_stream.update(
          'modal',
          template: "shared/pending_bulk"
        )
    end
  end

  protected

  def items
    "#{controller_name.singularize}_ids".to_sym
  end

  def model
    controller_name.singularize.camelize.constantize
  end

  def excel_collection_ids
    puts "search_params => #{search_params}"
    if params[:download_type] == "selected"
      collection_ids = model.with_images.where(id: params[items]).pluck(:id) if model == 'Product'
      collection_ids = model.where(id: params[items]).pluck(:id) if model != 'Product'
    end
    if params[:download_type] == "filtered"
      collection_ids = model.with_images.ransack(search_params).result(distinct: true).pluck(:id) if model == 'Product'
      collection_ids = model.all.ransack(search_params).result(distinct: true).pluck(:id) if model != 'Product'
    end
    if params[:download_type] == "all"
      collection_ids = model.with_images.pluck(:id) if model == 'Product'
      collection_ids = model.all.pluck(:id) if model != 'Product'
    end
    collection_ids
  end

end