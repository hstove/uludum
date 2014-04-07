module ImageHelper
  def filepicker_tag form, value, attr, attr_label=nil
    attr_label ||= attr.titleize
    html = content_tag :div, class: "field control-group" do
      label = form.label attr, attr_label, class: "control-label"
      success = content_tag :p, '', class: 'image-success'
      label + success + content_tag(:div, class: "controls") do
        clazz = value ? '' : 'hidden'
        preview = content_tag(:div, class: clazz) do
          content_tag(:div, class: 'image-preview pull-left') do
            filepicker_image_tag value, h: 120
          end
        end
        filepicker_opts = {
          button_class: 'btn',
          onchange: 'pickAvatar(event)',
          mimetype: 'image/*',
          button_text: "Choose #{attr_label}"
        }
        preview + form.filepicker_field(attr, filepicker_opts)
      end
    end
  end
end