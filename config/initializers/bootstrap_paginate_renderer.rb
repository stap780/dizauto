require 'will_paginate/view_helpers/link_renderer'
require 'will_paginate/view_helpers/action_view'

class BootstrapPaginateRenderer < WillPaginate::ActionView::LinkRenderer
    def html_container(html)
        tag(:ul, html, class: "pagination")
    end

    def previous_or_next_page(page, text, classname)
        if page
            tag(:li, link(text, page, class: "page-link"), class: "page-item")
        else
            tag(:li, tag(:a, text, class: "page-link"), class: "page-item disabled")
        end
    end

    def page_number(page)
        unless page == current_page
            tag(:li, link(page, page, class: "page-link"), class: "page-item")
        else
            tag(:li, tag(:a, page, class: "page-link"), class: "page-item active")
        end
    end

    def gap
        tag(:li, tag(:a, '&hellip;', class: "page-link"), class: "page-item disabled")
    end
end