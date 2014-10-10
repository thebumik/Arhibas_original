module ApplicationHelper
  def get_cats_params(categories, ids, type)
    result = []
    ids.each do |id|
      category = categories[id.last].first
      result << "#{id.first}: \"#{category.translation(I18n.locale).name}\""
      if type.eql?('page')
        result << "#{id.first}_url: \"#{page_path(I18n.locale, category.slug)}\""
      else
        result << "#{id.first}_url: \"#{category_path(I18n.locale, category)}\""
      end
    end
    result.join(", ")
  end

  def extra_css_inline
    css = []
    if settings[:background_use]
      css << %( background: ##{settings[:background_color]} )
      css << %( url('#{image_path(['custom/', settings[:background_image]].join)}') )
      css << %( #{settings[:background_repeat]} )
      css << %( #{settings[:background_x_position]} #{settings[:background_y_position]}; )
    else
      css << %( background-color: ##{settings[:background_color]}; )
    end
    css.join
    return "body {#{css}}".gsub(/\s+/, ' ')
  end

  def item_link(item, *args)
    options = args.shift || { :in_span => false }
    title = item.name
    link = options[:in_span] ? content_tag(:span, h(item.name)) : h(item.name)
    link_to link, admin_category_path(item), :title => h(title)
  end

  def display_breadcrumb(*args)
    options = args.shift || {}
    result = Array.new
    if not options[:before].blank?
      Array(options[:before]).each do |e|
        result << content_tag(:li, e)
      end
    end
    if @breadcrumb
      @breadcrumb[0..(options[:after].blank? ? -2 : -1)].each_with_index do |item, index|
        result << if !options[:icons].blank? && options[:icons].is_a?(Array) && options[:icons].size >= index + 1
          content_tag :li, item_link(item, :in_span => true), :class => ['icon', options[:icons][index].to_s].join(' ')
        else
          content_tag :li, item_link(item, :in_span => true)
        end
      end
      if options[:after].blank?
        result << if !options[:icons].blank? && options[:icons].is_a?(Array)
          content_tag :li, content_tag(:span, @breadcrumb.last.name), :class => ['icon', options[:icons].last.to_s].join(' ')
        else
          content_tag :li, content_tag(:span, @breadcrumb.last.name)
        end
      end
    end
    if not options[:after].blank?
      Array(options[:after]).each do |e|
        result << content_tag(:li, e)
      end
    end
    if !options[:after].blank? || !options[:before].blank? || @breadcrumb
      content_tag :ul, result.join, :class => :breadcrumb
    end
  end

  def markdown(text)
    text.blank? ? "" : Maruku.new(text).to_html
  end
end
