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
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-edit-2"><path d="M17 3a2.828 2.828 0 1 1 4 4L7.5 20.5 2 22l1.5-5.5L17 3z"></path></svg>'.html_safe
  end

  def trash_icon
  '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-trash-2"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path><line x1="10" y1="11" x2="10" y2="17"></line><line x1="14" y1="11" x2="14" y2="17"></line></svg>'.html_safe
  end
  
  def history_value(key, value)
    # puts key
    val = key.split('_id').first.classify.safe_constantize.find(value) if value.present? && key.include?('_id')
    val.present? && val.title ? val.title : value
  end

end
