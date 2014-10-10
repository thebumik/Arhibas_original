class PagesController < ApplicationController
  after_filter :write_sessions

  def home
    @projects = Project.limit(25).include([:photos, :translations]).published.in_sidebar.scoped :order => 'completion DESC'
    render 'home', :layout => 'home'
  end

  def show
    @page = Page.find_by_slug(params[:slug], :include => :translations)
    @page_translation = @page.translation(params[:locale])

    if @page.slug.eql?('contacts')
      @contact_form = ContactForm.new(params[:contact_form], request)
      if request.method.eql?(:post)
        if @contact_form.deliver
          flash[:notice] = t('simple_form.messages.success')
          return redirect_to(:action => :show)
        end
      end

      render 'contact'
    end
  end

  private
    def write_sessions
      session[:animation_type] ||= 'short'
    end
end
