module AdminHelper
  def rjs_flash(page, *args)
    options = args.shift || { :redirect => false }
    page.replace 'flash', :partial => 'common/admin/flash', :locals => { :flash => flash }
    flash.send options[:redirect] ? 'keep' : 'discard'
  end

  def default_flash(page)
    render :partial => 'common/admin/flash', :locals => { :flash => flash }
  end

  def flash_hide_link(*args)
    options = args.shift || {
      :name => 'hide me',
      :flash_block => 'flash'
    }
    link_to_function options[:name] do |page|
      page.visual_effect :fade, options[:flash_block], :duration => 0.3
    end
  end
end
