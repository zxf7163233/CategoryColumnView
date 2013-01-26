module ApplicationHelper
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