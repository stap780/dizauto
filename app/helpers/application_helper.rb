module ApplicationHelper
  # class LinkRenderer < WillPaginate::ActionView::LinkRenderer
  #   protected

  #   def html_container(html)
  #     tag(:ul, html, class: "pagination")
  #   end

  #   def previous_or_next_page(page, text, classname)
  #     if page
  #       tag(:li, link(text, page, class: "page-link"), class: "page-item")
  #     else
  #       tag(:li, tag(:a, text, class: "page-link"), class: "page-item disabled")
  #     end
  #   end

  #   def page_number(page)
  #     unless page == current_page
  #       tag(:li, link(page, page, class: "page-link"), class: "page-item")
  #     else
  #       tag(:li, tag(:a, page, class: "page-link"), class: "page-item active")
  #     end
  #   end

  #   def gap
  #     tag(:li, tag(:a, '&hellip;', class: "page-link"), class: "page-item disabled")
  #   end

  # end ## end of class LinkRenderer
  def flash_class(level)
    case level
    when "info" then "alert alert-info"
    when "notice", "success" then "alert alert-success"
    when "error" then "alert alert-danger"
    when "alert" then "alert alert-warning"
    end
  end

  # def bs_will_paginate(collection = nil, options = {})
  #   options, collection = collection, nil if collection.is_a? Hash
  #   options = options.merge(
  #     renderer: BootstrapPaginateRenderer, # ApplicationHelper::LinkRenderer,
  #     previous_label: "&laquo;",
  #     next_label: "&raquo;"
  #   )
  #   will_paginate(collection, options)
  # end

  def prepend_flash
    turbo_stream.prepend "our_flash", partial: "shared/flash"
  end

  def current_page_path_as_class
    cp = request.path.split("?").first[1..-1].tr("/", "_")
    cp.present? ? cp : "page-home"
  end

  def dropzone_controller_div_image
    data = {
      :controller => "dropzone",
      "dropzone-max-file-size" => "8",
      "dropzone-max-files" => "30",
      "dropzone-accepted-files" => "image/jpeg,image/jpg,image/png,image/gif",
      "dropzone-dict-file-too-big" => "You file {{filesize}}. Max size {{maxFilesize}} MB",
      "dropzone-dict-invalid-file-type" => "Wrong format. We accept .jpg, .png, .gif "
    }

    content_tag :div, class: "dropzone dropzone-default dz-clickable mt-4", data: data do
      yield
    end
  end

  def dropzone_controller_div_file
    data = {
      :controller => "dropzone",
      "dropzone-max-file-size" => "20",
      "dropzone-max-files" => "1",
      "dropzone-accepted-files" => "text/csv,text/xls,text/xlsx,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
      "dropzone-dict-file-too-big" => "You file {{filesize}}. Max size {{maxFilesize}} MB",
      "dropzone-dict-invalid-file-type" => "Wrong format. We accept .csv,.xls,.xlsx "
    }

    content_tag :div, class: "dropzone dropzone-default dz-clickable mt-4", data: data do
      yield
    end
  end

  def li_menu_link_to(name = nil, options = nil, html_options = nil, &block)
    status = request.path.start_with?(options) ? "active" : ""
    content_tag :li, class: "sidebar-item #{status}" do
      link_to(name, options, html_options, &block)
    end
  end

  def inline_error_for(field, form_obj)
    html = []
    if form_obj.errors[field].any?
      html << form_obj.errors[field].map do |msg|
        tag.div(msg, class: "invalid-feedback")
      end
    end
    html.join.html_safe
  end

  def sortable_icon
    '<i class="bi bi-arrows-move js-sort-handle fs-3"></i>'.html_safe
  end

  def sortable_with_badge(position)
    content_tag :i, class: "bi bi-arrows-move js-sort-handle fs-3 position-relative me-2" do
      content_tag(:span, position, class: "badge bg-info rounded-circle position-absolute fs-6 top-0 start-100 translate-middle border border-light", "data-sortable-target": "position")
    end
  end

  def check2_icon
    '<i class="bi bi-check2"></i>'.html_safe
  end

  def search_icon
    '<i class="bi bi-search"></i></span>'.html_safe
  end

  def arrow_down_up_icon
    '<i class="bi bi-arrow-down-up"></i>'.html_safe
  end

  def check_circle
    '<i class="bi bi-check-circle"></i>'.html_safe
  end

  def button_print
    '<button class="btn btn-outline-primary dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false"><i class="bi bi-printer"></i></button>'.html_safe
  end

  def button_download
    '<button class="btn btn-outline-primary dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">.xlsx</button>'.html_safe
  end

  def button_bulk_delete
    '<button class="btn btn-outline-primary dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false"><i class="bi bi-trash3"></i></button>'.html_safe
  end

  def history_icon
    '<i class="bi bi-clock-history"></i>'.html_safe
  end

  def close_icon
    '<i class="bi bi-x"></i>'.html_safe
  end

  def copy_icon
    '<i class="bi bi-copy"></i>'.html_safe
  end

  def barcode_icon
    '<i class="bi bi-upc"></i>'.html_safe
  end

  def arrow_left_icon
    '<i class="bi bi-arrow-left"></i>'.html_safe
  end

  def arrow_right_icon
    '<i class="bi bi-arrow-right"></i>'.html_safe
  end

  def caret_left_icon
    '<i class="bi bi-caret-left"></i>'.html_safe
  end

  def slider_vertical_icon
    '<i class="bi bi-sliders2-vertical"></i>'.html_safe
  end

  def arrow_clockwise_icon
    "<i class='bi bi-arrow-clockwise'></i>".html_safe
  end

  def false_icon
    '<i class="bi bi-x-circle"></i>'.html_safe
  end

  def more_icon
    '<i class="bi bi-three-dots"></i>'.html_safe
  end

  def download_icon
    '<i class="bi bi-cloud-arrow-down"></i>'.html_safe
  end

  def add_icon
    "<i class='bi bi-plus'></i> #{t("add")}".html_safe
  end

  def play_icon
    '<i class="bi bi-play"></i>'.html_safe
  end

  def edit_icon
    '<i class="bi bi-pencil"></i>'.html_safe
  end

  def trash_icon
    '<i class="bi bi-trash3"></i>'.html_safe
  end

  def eye_icon
    '<i class="bi bi-eye"></i>'.html_safe
  end

  def history_value(key, value)
    # puts "history_value => key #{key.to_s} // value #{value.to_s}"
    if key.include?("_id")
      search_key = "company" if key == "strah_id"
      search_key = "user" if key == "manager_id"
      search_key = "warehouse" if key == "origin_warehouse_id"
      search_key = "warehouse" if key == "destination_warehouse_id"
      search_key = key.split("_id").first if key != "strah_id" && key != "manager_id" && key != "origin_warehouse_id" && key != "destination_warehouse_id"

      val = search_key.classify.safe_constantize.where(id: value).present? ? search_key.classify.safe_constantize.find_by_id(value.to_i) : nil
      return_value = val.title if val.present? && val.respond_to?(:title)
      return_value = val.short_title if val.present? && val.respond_to?(:short_title)
      return_value = val.name if val.present? && val.respond_to?(:name)
      return_value.present? ? return_value : value.to_s
    else
      value
    end
  end

  def div_check_box_tag_all
    content_tag :div, class: "col-1" do
      check_box_tag("selectAll", "selectAll", class: "checkboxes form-check-input", data: {selectall_target: "checkboxAll", action: "change->selectall#toggleChildren"})
    end
  end

  def th_check_box_tag_all
    content_tag :th do
      check_box_tag("selectAll", "selectAll", class: "checkboxes form-check-input", data: {selectall_target: "checkboxAll", action: "change->selectall#toggleChildren"})
    end
  end

  def td_index_edit_delete_link(obj)
    content_tag :td, class: "align-middle" do
      content_tag :span, class: "no-wrap d-flex justify-content-end gap-2 align-items-center" do
        render "shared/edit_delete_link", object: obj
      end
    end
  end

  def tabs_head(collection, tabs)
    items = tabs.map.with_index { |tab, index| tab_a_tag(tab, index.zero?) }
    content_tag(:ul, safe_join(items), class: "nav nav-pills text-capitalize", id: collection + "_tabs", role: "tablist")
  end

  def tab_a_tag(tab, is_active)
    content_tag :li, class: "nav-item border border-primary rounded", role: "presentation" do
      options = {
        class: (is_active ? "nav-link active" : "nav-link"),
        id: tab[0] + "_tab_header",
        "data-bs-toggle": "tab",
        "data-bs-target": "#" + tab[0] + "_tab",
        role: "presentation"
      }
      content_tag :a, options do
        tab[1]
      end
    end
  end

  def td_remove_nested(obj)
    content_tag :td do
      render "shared/nested_delete", object: obj
    end
  end

  def div_remove_nested(obj)
    content_tag :div, class: "col-md-2 d-flex justify-content-start" do
      render "shared/nested_delete", object: obj
    end
  end

  def current_page_active?(page)
    request.path.start_with?("/#{page}")
  end
end
