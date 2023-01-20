module ApplicationHelper

    
    def current_page_path_as_class
        cp = request.path.split("?").first[1..-1].gsub("/","_")
        cp.present? ? cp : 'page-home'
    end


end
