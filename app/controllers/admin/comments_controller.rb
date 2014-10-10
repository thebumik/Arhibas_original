class Admin::CommentsController < AdminController
  def index
    per_page = params[:per_page] || 10
    @comments = Comment.paginate :include => [:project], :page => params[:page], :order => 'created_at DESC', :per_page => per_page

    if per_page.to_i > 1 && @comments.blank?
      redirect_to admin_comments_path(:per_page => params[:per_page], :page => 1)
      return
    end
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        flash[:notice] = 'Comment was successfully updated.'
        format.html { redirect_to admin_comments_path }
        format.js
      else
        flash[:error] = @comment.errors.full_messages.join('<br />')
        format.html { render :action => 'edit', :status => 403 }
        format.js { render :status => 403 }
      end
    end
  end
  
  def create
    comments = Comment.find(params[:comments_ids]) rescue []

    respond_to do |format|
      unless params[:commit].blank?
        case params[:commit]
          when 'delete'
            if comments.any? && comments.each(&:destroy)
              flash[:notice] = 'Selected comments has been successfully destroyed.'
            else
              flash[:error] = 'Sorry, could not destroy anything...'
            end

          when 'activate'
            if comments.any? && Comment.update_all(["active = ?", true], ["id in (?)", comments])
              flash[:notice] = 'Selected comments has been successfully approved.'
            else
              flash[:error] = 'Sorry, could not approve anything...'
            end
        end
      else
        flash[:error] = "Sorry, but something gone wrong... :("
      end

      # now redirect
      format.html { redirect_to admin_comments_path }
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      flash[:notice] = 'Comment was successfully destroyed.'
      format.html { redirect_to admin_comments_path(:per_page => params[:per_page], :page => params[:page] ) }
      format.js
    end
  end
end
