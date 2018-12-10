module ApplicationHelper
  def flashes(dismissable = true)
    content_tag :div do
      content = ''
      content += resource_flash_alert(dismissable).to_s unless error_resource.nil?
      content += flash_alert(dismissable)

      content.html_safe
    end
  end

  private

  def flash_alert(dismissable = true)
    flash.map do |key, value|
      is_error_alert = key.to_s.eql?('alert') || key.to_s.eql?('error')

      flash_type = is_error_alert ? :danger : :success
      flash_text = is_error_alert ? 'error' : 'success'

      flash_box type: flash_type, dismissable: dismissable do
        content_tag(:strong, (t "views.defaults.#{flash_text}")) + " #{value}"
      end
    end.join.html_safe
  end

  def resource_flash_alert(dismissable = true)
    flash_box type: :danger, dismissable: dismissable do
      error_resource.errors.messages.map do |attribute, messages|
        next if messages.empty?
        content = content_tag(:strong, (t 'views.defaults.error'))
        content += content_tag(:span, " #{attribute.to_s.humanize.capitalize}:")
        content += content_tag(:ul) do
          messages.each.map do |message|
            content_tag(:li, message)
          end.join.html_safe
        end
        content.html_safe
      end.join.html_safe
    end unless error_resource.errors.empty?
  end

  def flash_box(type: :success, dismissable: true, &block)
    content_tag :div, class: "alert alert-#{type} fade in" do
      content = dismissable ? hide_flash_box_button : ''.html_safe
      content += capture(&block)
      content
    end
  end

  def hide_flash_box_button
    content_tag(:button, type: 'button', class: 'close', data: { dismiss: 'alert' }) do
      content_tag(:i, ' ', class: 'fa fa-times-circle fa-fw fa-1')
    end
  end

  def error_resource
    return @resource if @resource
    return resource if respond_to?(:resource) && !resource.nil? && resource.respond_to?(:errors) && !resource.errors.nil?
    nil
  end
end
