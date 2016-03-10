class Admin::CategoriesController < Admin::BaseController
  cache_sweeper :blog_sweeper

  def index; redirect_to :action => 'new' ; end
    
  def edit
    if params[:id].nil?
      new
    else
      new_or_edit
    end
  end

  def new 
    respond_to do |format|
      format.html { new_helper }
      format.js { 
        @category = Category.new
      }
    end
  end

  def destroy
    @record = Category.find(params[:id])
    return(render 'admin/shared/destroy') unless request.post?

    @record.destroy
    redirect_to :action => 'new'
  end

  private
  
  def new_helper
    @categories = Category.find(:all)
    if request.post?
      @category = Category.new(params[:category])
      respond_to do |format|
        format.html { save_category }
        format.js do
          @category.save
          @article = Article.new
          @article.categories << @category
          return render(:partial => 'admin/content/categories')
        end
      end 
      return 
    else
      @category = Category.new
      render 'new'
    end
  end

  def new_or_edit
    @categories = Category.find(:all)
    @category = Category.find(params[:id])
    @category.attributes = params[:category]
    if request.post?
      respond_to do |format|
        format.html { save_category }
        format.js do 
          @category.save
          @article = Article.new
          @article.categories << @category
          return render(:partial => 'admin/content/categories')
        end
      end
      return
    end
    render 'new'
  end

  def save_category
    if @category.save!
      flash[:notice] = _('Category was successfully saved.')
    else
      flash[:error] = _('Category could not be saved.')
    end
    redirect_to :action => 'new'
  end

end
