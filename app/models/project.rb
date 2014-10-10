# == Schema Information
#
# Table name: projects
#
#  id                :integer         not null, primary key
#  name              :string(255)
#  customer          :string(255)
#  location          :string(255)
#  arhitect          :string(255)
#  completion        :integer
#  position          :integer
#  description       :text
#  created_at        :datetime
#  updated_at        :datetime
#  published         :boolean         default(TRUE)
#  category_id       :integer
#  rating_avg        :decimal(10, 2)  default(0.0)
#  rating_total      :integer         default(0)
#  rating_last_value :integer
#  body              :text
#  body_markdown     :text
#  in_sidebar        :boolean         default(TRUE)
#

class Project < ActiveRecord::Base
  belongs_to :category
  has_many :photos, :dependent => :destroy
  has_many :votes, :dependent => :destroy
  has_many :comments, :dependent => :destroy

  # translations management
  has_many :translations, :as => :translationable, :dependent => :destroy

  # +++ nested attributes
  accepts_nested_attributes_for :comments

  # +++ validation
  validates_presence_of :name

  # +++ attributes
  accepts_nested_attributes_for :translations

  # +++ callbacks
  before_save :body_markdown_cleanup, :write_body_markdown

  # +++ named scopes
  named_scope :published, :conditions => { :published => true }
  named_scope :in_sidebar, :conditions => { :in_sidebar => true }

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
  def save_rating!
    x = rating_avg.to_f * rating_total.to_f
    self.rating_total = rating_total.to_i + 1
    self.rating_avg = (x + rating_last_value.to_f) / rating_total.to_f

    self.save!
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

  def translation(locale)
    (translations.index_by(&:lang)[locale.to_s] rescue nil) || self
  end

  def to_param
    "#{id} #{name}".parameterize
  end

  def write_body_markdown
    markup = radiance(body_markdown)
    self.body = markup.blank? ? "" : ApplicationController.helpers.markdown(markup)

    # clean multiple lines
    self.body = self.body.gsub(/\n+/, "\n") unless body.blank?
  end

  def photo_attributes=(photo_attributes)
    photo_attributes.each do |attributes|
      photos.build(attributes)
    end
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
