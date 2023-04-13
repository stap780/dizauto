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

  
end
