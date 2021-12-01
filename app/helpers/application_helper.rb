module ApplicationHelper
    def active_class(link_path)
        request.url.include?(link_path) ? "active" : ""
    end
end
