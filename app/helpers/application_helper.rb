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
      when 'info' then "alert alert-info"
      when 'notice','success' then "alert alert-success"
      when 'error' then "alert alert-danger"
      when 'alert' then "alert alert-warning"
    end
  end
  
  def bs_will_paginate(collection = nil, options = {})
    options, collection = collection, nil if collection.is_a? Hash
    options = options.merge(
      renderer: BootstrapPaginateRenderer, #ApplicationHelper::LinkRenderer,
      previous_label: "&laquo;",
      next_label: "&raquo;"
    )
    will_paginate(collection, options)
  end

  def prepend_flash
      turbo_stream.prepend 'our_flash', partial: 'shared/flash'
  end
  
  def current_page_path_as_class
      cp = request.path.split("?").first[1..-1].gsub("/","_")
      cp.present? ? cp : 'page-home'
  end

  def dropzone_controller_div
      data = {
        controller: "dropzone",
        'dropzone-max-file-size'=>"8",
        'dropzone-max-files' => "20",
        'dropzone-accepted-files' => 'image/jpeg,image/jpg,image/png,image/gif',
        'dropzone-dict-file-too-big' => "Váš obrázok ma veľkosť {{filesize}} ale povolené sú len obrázky do veľkosti {{maxFilesize}} MB",
        'dropzone-dict-invalid-file-type' => "Nesprávny formát súboru. Iba obrazky .jpg, .png alebo .gif su povolene",
      }
  
      content_tag :div, class: 'dropzone dropzone-default dz-clickable mt-4', data: data do
        yield
      end
  end

  def li_menu_link_to(name = nil, options = nil, html_options = nil, &block)
    status = current_page?(options) ?  'active' : ''
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

  def edit_icon
    '<i class="bi bi-pencil"></i>'.html_safe
  end

  def trash_icon
    '<i class="bi bi-trash3"></i>'.html_safe
  end
  
  def history_value(key, value)
    # puts key
    val = key.split('_id').first.classify.safe_constantize.find(value) if value.present? && key.include?('_id')
    val.present? && val.title ? val.title : value
  end

  def th_check_box_tag_all
    content_tag :th do
      check_box_tag( 'selectAll', 'selectAll', false, data: {selectall_target: 'checkboxAll', action: 'change->selectall#toggleChildren'} )
    end
  end

  def td_index_edit_delete_link(obj)
    content_tag :th, class: 'align-middle' do
      content_tag :span, class: "no-wrap d-flex align-items-center" do
        render 'shared/edit_delete_link', object: obj 
      end
    end
  end

end
