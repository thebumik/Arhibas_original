# == Schema Information
#
# Table name: pages
#
#  id            :integer         not null, primary key
#  name          :string(255)
#  body          :text
#  body_markdown :text
#  position      :integer
#  published     :boolean         default(TRUE)
#  created_at    :datetime
#  updated_at    :datetime
#  slug          :string(255)
#

require 'radius'
require 'lib/slugalizer'

class Page < ActiveRecord::Base
  default_scope :order => 'created_at DESC'

  # translations management
  has_many :translations, :as => :translationable, :dependent => :destroy
  has_many :assets, :as => :assetable, :dependent => :destroy

  # +++ validation
  validates_presence_of :name
  validates_uniqueness_of :slug

  # +++ attributes
  accepts_nested_attributes_for :translations, :assets

  # +++ callbacks
  before_save :body_markdown_cleanup, :slugify, :write_body_markdown

  # +++ named scopes
  named_scope :published, :conditions => { :published => true }
  named_scope :limit, lambda{|limit|
    { :limit => limit }
  }
  named_scope :include, lambda{|what|
    { :include => what }
  }
  named_scope :exclude, lambda{|what|
    { :conditions => ["id not in (?)", what] }
  }

  # +++ instance methods
  # ---------------------------------------------------------------------- #
  def build_associations
    ['translations', 'assets'].each do |m|
      if not self.send(m).exists?
        self.send([m, '='].join, m.capitalize.constantize.new) unless ['translations', 'assets'].include?(m)
        if m.eql?('translations')
          ['en', 'ru'].each {|i| self.send(m).build :lang => i }
        else
          self.send(m).build
        end
      end
    end
  end

  def slugify
    slug = Slugalizer.slugalize(self.slug.blank? ? self.name : self.slug)
    self.slug = "#{slug}"
  end

  def translation(locale)
    (self.translations.index_by(&:lang)[locale.to_s] rescue nil) || self
  end

  def write_body_markdown
    markup = radiance(body_markdown)
    self.body = markup.blank? ? "" : ApplicationController.helpers.markdown(markup)

    # clean multiple lines
    self.body = self.body.gsub(/\n+/, "\n") unless body.blank?
  end

  def to_param
    "#{id} #{name}".parameterize
  end

  private
    def body_markdown_cleanup
      self.body_markdown = body_markdown.gsub(/»/, '>>').gsub(/«/, '<<').gsub(/“|”/, '"').gsub(/‘|’/, "'") unless body_markdown.blank?
    end

    def radiance(content, html_options = {})
      return if content.blank?

      context = Radius::Context.new do |c|
        ['left', 'right', 'center', 'flat'].each do |align|
          c.define_tag "img_#{align}" do |tag|
            size = tag.attr['size'] || :original

            html_options[:src] = Asset.find(tag.attr['id']).data.url(size.to_sym)
            html_options[:align] = align unless align.eql?('flat')
            html_options[:class] = tag.attr['class'] unless tag.attr['class'].blank?
            html_options[:alt] = tag.attr['alt'] unless tag.attr['alt'].blank?

            result = ApplicationController.helpers.tag(:img, html_options)
            result = "<div>#{result}</div>" if align.eql?('flat')
            result
          end
        end
      end
      parser = Radius::Parser.new(context, :tag_prefix => 'x')
      parser.parse(content)
    end
end
