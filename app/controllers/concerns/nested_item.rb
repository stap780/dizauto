# frozen_string_literal: true

# NestedItem
module NestedItem
  extend ActiveSupport::Concern

  included do
    include ActionView::Helpers::FormHelper
  end

  def slimselect_nested_item
    target = params[:turboId]
    item = nested_model.find_by(id: target.remove("#{model_to_s}_item_"))
    variant = Variant.find(params[:selected_id])
    child_index = model_to_s == 'stocktransfer' ? target.remove('stock_transfer_item_') : target.remove("#{model_to_s}_item_")

    if item.present?
      helpers.fields model: model.new do |f|
        f.fields_for nested_model_pluralize_to_sym, item do |ff|
          render turbo_stream: turbo_stream.replace(
            target,
            partial: 'shared/items_form_data',
            locals: {
              f: ff,
              variant: variant,
              nested_url: nested_url,
              object_turbo_frame_tag: "#{nested_model_to_s}_#{ ff.object.persisted? ? ff.object.id : child_index}",
              remove_element_path: "/#{model_pluralize_to_s}/remove_nested?#{nested_model_to_s}_id=#{ ff.object.persisted? ? ff.object.id : child_index }",
              discount_field: check_discount
            }
          )
        end
      end
    else
      helpers.fields model: model.new do |f|
        f.fields_for nested_model_pluralize_to_sym, nested_model.new, child_index: child_index do |ff|
          render turbo_stream: turbo_stream.replace(
            target,
            partial: 'shared/items_form_data',
            locals: {
              f: ff,
              variant: variant,
              nested_url: nested_url,
              object_turbo_frame_tag: "#{nested_model_to_s}_#{ ff.object.persisted? ? ff.object.id : child_index}",
              remove_element_path: "/#{model_pluralize_to_s}/remove_nested?#{nested_model_to_s}_id=#{ ff.object.persisted? ? ff.object.id : child_index }",
              discount_field: check_discount
            }
          )
        end
      end
    end
  end

  def new_nested
    puts "new_nested => model = #{model} /// nested_model = #{nested_model} /// nested_url = #{nested_url} /// nested_model_to_s = #{nested_model_to_s}"
    child_index = Time.now.to_i
    puts "new_nested child_index => #{child_index}"
    helpers.fields model: model.new do |f|
      f.fields_for nested_model_pluralize_to_sym, nested_model.new, child_index: child_index do |ff|
        render turbo_stream: turbo_stream.append(
          nested_model_pluralize_to_s,
          partial: 'shared/items_form_data',
          locals: {
            f: ff,
            variant: nil,
            nested_url: nested_url,
            object_turbo_frame_tag: "#{nested_model_to_s}_#{ ff.object.persisted? ? ff.object.id : child_index}",
            remove_element_path: "/#{model_pluralize_to_s}/remove_nested?#{nested_model_to_s}_id=#{ ff.object.persisted? ? ff.object.id : child_index }",
            discount_field: check_discount
          }
        )
      end
    end
  end

  def remove_nested
    params_item_id = params["#{nested_model_to_s}_id"]
    item = nested_model.find_by(id: params_item_id)
    item.delete if item.present?
    remove_element = "#{nested_model_to_s}_#{params_item_id}"
    puts "remove_element => #{remove_element}"

    flash.now[:success] = t('.success')
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(remove_element),
          render_turbo_flash,
          turbo_stream.append(nested_model_pluralize_to_s, partial: 'shared/recalculate')
        ]
      end
      format.json { head :no_content }
    end
  end

  private

  def model
    controller_name.singularize.camelize.constantize
  end

  def model_to_s
    model.to_s.downcase
  end

  def model_pluralize_to_s
    if model_to_s == 'stocktransfer'
      'stock_transfers'
    else
      model.to_s.pluralize.downcase
    end
  end

  def nested_model
    "#{model}_item".singularize.camelize.constantize
  end

  def nested_model_to_s
    if model_to_s == 'stocktransfer'
      'stock_transfer_item'
    else
      "#{model}_item".downcase
    end
  end

  def nested_model_pluralize_to_s
    if model == 'Placement'
      'location'.pluralize.downcase
    elsif model_to_s == 'stocktransfer'
      'stock_transfer_item'.pluralize.downcase
    else
      "#{model}_item".pluralize.downcase
    end
  end

  def nested_model_pluralize_to_sym
    nested_model_pluralize_to_s.to_sym
  end

  def nested_url
    if model_to_s == 'stocktransfer'
      '/stock_transfers/slimselect_nested_item'
    else
      "/#{model_pluralize_to_s}/slimselect_nested_item"
    end
  end

  def check_discount
    with_discount = %w[order_items invoice_items]
    with_discount.include?(nested_model_pluralize_to_s)
  end

end