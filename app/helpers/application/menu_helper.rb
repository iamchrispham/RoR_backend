module Application
  module MenuHelper
    def menu_section(title:)
      content_tag(:div, class: 'clearfix hidden-xs user-left-box') do
        content_tag(:div, class: 'user-box') do
          content_tag(:span, title, class: 'name')
        end
      end
    end

    def menu_item(controller:, path:, title:, exclude: nil)
      normalised_controller_path = controller_path.gsub('/','_')

      exclude = [exclude] unless exclude.is_a?(Array)

      full_match = normalised_controller_path.eql?(controller.to_s)
      partial_match = normalised_controller_path.starts_with?(controller.to_s)
      excluded = exclude.include?(controller)

      item_class =  full_match || (partial_match && !excluded)  ? 'active' : ''
      content_tag(:li, class: item_class) do
        link_to path do
          content_tag(:span, title.to_s)
        end
      end
    end

    def back_arrow_item(url=nil)
      content_tag(:div, class: "chevron left") do
        link_to "", url.present? ? url : url_for(:back)
      end
    end

    def active_controller(controller:)
      controller_path.gsub('/','_').eql?(controller.to_s) ? 'active' : ''
    end

  end
end
