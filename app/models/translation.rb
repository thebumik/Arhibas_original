# == Schema Information
#
# Table name: translations
#
#  id                   :integer         not null, primary key
#  name                 :string(255)
#  customer             :string(255)
#  location             :string(255)
#  arhitect             :string(255)
#  description          :text
#  translationable_id   :integer
#  translationable_type :string(255)
#  lang                 :string(255)
#  body                 :text
#  body_markdown        :text
#

require 'radius'
require 'lib/slugalizer'

class Translation < ActiveRecord::Base
  belongs_to :translationable, :polymorphic => true
  has_many :assets, :as => :assetable, :dependent => :destroy

  # +++ callbacks
  before_save :body_markdown_cleanup, :write_body_markdown

  def write_body_markdown
    markup = radiance(body_markdown)
    self.body = markup.blank? ? "" : ApplicationController.helpers.markdown(markup)

    # clean multiple lines
    self.body = self.body.gsub(/\n+/, "\n") unless body.blank?
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
