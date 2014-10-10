module Admin::CategoriesHelper
  def display_nested_tree(tree, level = 0)
    haml_tag :ul do
      for node in tree do
        if node.level_stage.eql?(level)
          haml_tag :li do
            yield node
            temp_tree = []
            tree.each do |i|
              temp_tree << i unless (i.left < node.left || i.right > node.right)
            end
            display_nested_tree(temp_tree, node.level_stage + 1) { |n| yield n } unless node.leaf?
          end
        end
      end
    end
  end

  def tree_link_to(object)
    ret = link_to h(object.name), :action => :show, :id => object
    ret += content_tag :span, link_to('add new', new_admin_category_path(:parent => object.id)), :class => :add_new_subcat
    ret += content_tag :span, link_to('delete', admin_category_path(object), :method => :delete, :confirm => 'Are you sure?'), :class => :subcat_delete
  end
end
