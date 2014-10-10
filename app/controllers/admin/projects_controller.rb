class Admin::ProjectsController < AdminController
  # Filters
  before_filter :current_project, :sessions

  def index
    @projects = Project.paginate :include => [:category], :page => @page_num, :order => 'created_at DESC', :per_page => @per_page

    if @per_page > 1 && @projects.blank?
      redirect_to admin_projects_path(:per_page => @per_page, :page => 1)
      return
    end
  end
  
  def show
  end

  def new
    @project = Project.new
    @project.build_associations

    @project.category = Category.find(params[:parent]) if Category.exists?(params[:parent])
    1.upto(3) { @project.photos.build }

    respond_to do |format|
      format.html
      format.xml  { render :xml => @project }
    end
  end

  def edit
    @project = Project.find(params[:id])
    @project.build_associations

    if not @project.photos.exists? && @project.photos.size > 3
      1.upto(3) { @project.photos.build }
    end
  end

  def create
    @project = Project.new(params[:project])

    respond_to do |format|
      if @project.save
        flash[:notice] = 'Project was successfully created.'
        format.html { redirect_to admin_projects_path }
      else
        flash[:error] = @project.errors.full_messages.join('<br />')
        format.html { render :action => 'new', :status => 403 }
        format.js { render :status => 403 }
      end
    end
  end

  def update
    params[:photo_ids] ||= []
    unless params[:photo_ids].empty?
      Photo.destroy_pics(params[:id].to_i, params[:photo_ids])
    end

    respond_to do |format|
      if @project.update_attributes(params[:project])
        flash[:notice] = 'Project was successfully updated.'
        format.html { redirect_to admin_projects_path }
        format.xml  { head :ok }
        format.js
      else
        flash[:error] = @project.errors.full_messages.join('<br />')
        format.html { render :action => 'edit', :status => 403 }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
        format.js { render :status => 403 }
      end
    end
  end

  def destroy
    @project.destroy

    respond_to do |format|
      flash[:notice] = 'Project was successfully destroyed.'
      format.html { redirect_to admin_projects_path }
      format.js
    end
  end

  # Private methods
  private
    def sessions
      session[:per_page] = params[:per_page] || session[:per_page] || 10
      @per_page = session[:per_page].to_i

      session[:page_num] = params[:page] || session[:page_num] || 1
      @page_num = session[:page_num].to_i
    end

    def current_project
      current_project = params[:project_id].blank? ? params[:id] : params[:project_id]
      @project = Project.find(current_project) unless current_project.blank?
    end
end
