class Category < ActiveRecord::Base
  attr_accessible :name
  acts_as_tree
  has_many :products

  def load_category(config_root)
    # clear all category children
    create_node(config_root, root)
    root.save
  end

  def load_file(file)
    config_root = YAML.load_file(file)["category"]
    load_category(config_root)
  end

  def create_node(_config_parent, _tree_parent)
    _config_parent.each do |config|
      # child = Category.create(name: config["name"])
      child = _tree_parent.children.create!(name: config["name"])
      if config["children"] && config["children"].is_a?(Array)
        child.create_node(config["children"], child)
      end
    end
  end
end

Category.create(:name => :root) unless Category.root
