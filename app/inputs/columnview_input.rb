class ColumnviewInput < SimpleForm::Inputs::Base

  class MyHelper
    include ActionView::Helpers
    attr_accessor :output_buffer
    def build_menu(root)
     output = ActiveSupport::SafeBuffer.new
     if root.children && root.children.size && root.children.size > 0

      content_tag(:ul, :class => "dropdown-menu") do 
        root.children.map do |node|

          if node.children && node.children.size > 0
            output.concat(content_tag(:li, :class => 'dropdown-submenu') do 
              link_to(node.name.humanize, '#', :html => {tabindex: -1}) + 
              build_menu(node)
            end)
          else
            output.concat(content_tag(:li) do 
              link_to node.name.humanize, '#'
            end)
          end

        end
        output
      end
     end

    end
  end

  def input
    @helpes ||= MyHelper.new
    <<-HTML
        #{@helpes.build_menu(@builder.object.send(attribute_name))} 
        #{@builder.hidden_field(attribute_name, input_html_options)}
        <script type="text/javascript">
            $("ul.dropdown-menu").first().columnview({field_name: '#{field_name}'});
        </script>
    HTML
    .html_safe
  end

  def field_name
    "#{lookup_model_names.join("_")}_#{reflection_or_attribute_name}"
  end 
end