class Admin::CategoriesController < AdminController
  # Filters
  before_filter :current_category

  def index
    @categories = Category.roots
  end

  def show
    add_breadcrumb(@category.self_and_ancestors)
  end

  def new
    @category = Category.new
    @category.build_associations

    add_breadcrumb Category.find(params[:parent]).self_and_ancestors unless params[:parent].blank?
  end

  def edit
    @category.build_associations
    add_breadcrumb @category.self_and_ancestors
  end

  def create
    @category = Category.new(params[:category])

    respond_to do |format|
      if @category.save
        # move category to child of the selected parent
        @category.move_to_child_of(params[:category][:parent_id]) if not params[:category][:parent_id].blank?

        flash[:notice] = 'Category was successfully created.'
        format.html { redirect_to @category.root? ? admin_categories_path : admin_category_path(@category.parent) }
      else
        flash[:error] = 'Category could not be created.'
        format.html { render :action => 'new', :status => 403 }
        format.js { render :status => 403 }
      end
    end
  end

  def update
    respond_to do |format|
      if @category.update_attributes(params[:category])
        # move category to child of the selected parent
        @category.move_to_child_of(params[:category][:parent_id]) if not params[:category][:parent_id].blank?

        flash[:notice] = 'Category was successfully updated.'
        format.html { redirect_to admin_categories_path }
        format.js
      else
        flash[:error] = @category.errors.full_messages.join('<br />')
        format.html { render :action => 'edit', :status => 403 }
        format.js { render :status => 403 }
      end
    end
  end

  def destroy
    @category.destroy

    respond_to do |format|
      flash[:notice] = 'Category was successfully destroyed.'
      format.html { redirect_to admin_categories_path }
      format.js
    end
  end

  # Private methods
  private
    def current_category
      current_category = params[:category_id].blank? ? params[:id] : params[:category_id]
      @category = Category.find(current_category) unless current_category.blank?
    end

    def get_categories
      @categories = Category.all
    end
end
