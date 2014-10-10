# == Schema Information
#
# Table name: categories
#
#  id          :integer         not null, primary key
#  position    :integer
#  name        :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#  parent_id   :integer
#  published   :boolean         default(TRUE)
#  lft         :integer
#  rgt         :integer
#  stage       :integer
#

class Category < ActiveRecord::Base
  default_scope :order => 'position'
  acts_as_nested_set

  has_many :projects
  
  # translations management
  has_many :translations, :as => :translationable, :class_name => 'Translation', :dependent => :destroy

  # +++ callbacks
  before_create :set_position
  after_move :update_nodes_stage

  # +++ validation
  validates_presence_of :name

  # +++ attributes
  accepts_nested_attributes_for :translations

  # +++ named scopes
  named_scope :limit, lambda{|limit|
    { :limit => limit }
  }
  named_scope :include, lambda{|what|
    { :include => what }
  }
  named_scope :exclude, lambda{|what|
    { :conditions => ["id not in (?)", what] }
  }

  # +++ class methods
  # ---------------------------------------------------------------------- #
  def self.restage!
    Category.all.each do |category|
      category.stage = category.level
      category.save!
    end
  end

  # +++ instance methods
  # ---------------------------------------------------------------------- #
  def translation(locale)
    (self.translations.index_by(&:lang)[locale.to_s] rescue nil) || self
  end

  def to_param
    "#{id} #{name}".parameterize
  end

  def set_position
    #self.position = defined?(self.ancestors) ? (self.ancestors.size + 1) : 1
  end

  def level_stage
    if self.stage.blank?
      self.stage = self.level
      self.save!
    end
    self.stage
  end

  def build_associations
    ['translations'].each do |m|
      if not self.send(m).exists?
        self.send([m, '='].join, m.capitalize.constantize.new) unless ['translations'].include?(m)
        if m.eql?('translations')
          ['en', 'ru'].each {|i| self.send(m).build :lang => i }
        else
          self.send(m).build
        end
      end
    end
  end

  private
    # save node level to db --> stage
    def update_nodes_stage
      self.self_and_descendants.each do |i|
        level = i.level
        unless i.stage.eql?(level)
          i.stage = level
          i.save!
        end
      end
    end
end
