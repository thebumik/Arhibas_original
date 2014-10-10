class Admin::PagesController < AdminController
  # Filters
  before_filter :current_page

  def index
    @pages = Page.all :include => 'translations'
  end

  def show
  end

  def new
    @page = Page.new
    @page.build_associations

    1.upto(3) { @page.assets.build }

    respond_to do |format|
      format.html
      format.xml  { render :xml => @page }
    end
  end

  def edit
    @page.build_associations

    if not @page.assets.exists? && @page.assets.size > 3
      1.upto(3) { @page.assets.build }
    end
  end

  def create
    @page = Page.new(params[:page])

    respond_to do |format|
      if @page.save
        flash[:notice] = 'Page was successfully created.'
        format.html { redirect_to admin_pages_path }
      else
        flash[:error] = @page.errors.full_messages.join('<br />')
        format.html { render :action => 'new', :status => 403 }
        format.js { render :status => 403 }
      end
    end
  end

  def update
    params[:asset_ids] ||= []
    unless params[:asset_ids].empty?
      Asset.destroy_pics('Page', params[:id].to_i, params[:asset_ids])
    end

    respond_to do |format|
      if @page.update_attributes(params[:page])
        flash[:notice] = 'Page was successfully updated.'
        format.html { redirect_to admin_pages_path }
        format.xml  { head :ok }
        format.js
      else
        flash[:error] = @page.errors.full_messages.join('<br />')
        format.html { render :action => 'edit', :status => 403 }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
        format.js { render :status => 403 }
      end
    end
  end

  def destroy
    @page.destroy

    respond_to do |format|
      flash[:notice] = 'Page was successfully destroyed.'
      format.html { redirect_to admin_pages_path }
      format.js
    end
  end

  # Private methods
  private
    def current_page
      current_page = params[:page_id].blank? ? params[:id] : params[:page_id]
      @page = Page.find(current_page) unless current_page.blank?
    end
end
