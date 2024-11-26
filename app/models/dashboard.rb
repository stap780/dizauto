class Dashboard < ApplicationRecord
  SEARCHABLE_MODEL_ATTRIBUTES = {
    "Incase" => ["unumber", "carnumber", "stoanumber"],
    # "Order" => ["id"],
    "User" => ["name", "phone", "email"],
    "Company" => ["short_title", "title"],
    "Variant" => ["product_title","barcode", "sku"]
  }

  def self.search(params_query)
    @search_results = {}
    if params_query.present?
      SEARCHABLE_MODEL_ATTRIBUTES.each do |model_name, searchable_fields|
        #model_results = model_name.constantize.where(searchable_fields.map { |field| "#{field} ILIKE :query" }.join(" OR "), query: "%#{params_query}%").uniq
        model_results = model_name.constantize.ransack("#{searchable_fields.join('_or_')}_matches_all": "%#{params_query}%").result.uniq
        mew_searchable_fields = model_name == 'Variant' ? ["product_id"] + searchable_fields : ["id"] + searchable_fields
        convert_model_results = []
        model_results.each do |item|
          value = mew_searchable_fields.map { |attr| attr == 'product_title' ? item.send('title') : item.send(attr) }
          convert_model_results.push(value)
        end
        @search_results[model_name] = convert_model_results
      end
    else
      @search_results["Empty"] = ["no results"]
    end
    @search_results
  end
end
