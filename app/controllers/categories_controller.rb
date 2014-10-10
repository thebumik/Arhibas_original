class CategoriesController < ApplicationController
  layout "projects"

  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id], :include => [ :translations, { :projects => :photos } ])
    @category_translation = @category.translation(params[:locale])

    if @category.id.eql?(97)
      @book_box = {
        89 => 'ppp',
        88 => 'epos',
        87 => 'aramis',
        86 => 'calculator',
        85 => 'monomax',
        84 => 'lira'
      }
      render 'show_soft'
      return
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :layout => false }
    end
  end
end
