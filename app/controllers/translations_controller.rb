class TranslationsController < ApplicationController
  # GET /translations
  # GET /translations.xml
  def index
    @translations = Translation.order("key, locale")
    @translations = @translations.where(:locale=>params[:locale]) if params[:locale]
    @translations = @translations.where(:key=>params[:key]) if params[:key]
  end

  def edit_multiple
    @translations = Translation.find(params[:translation_ids])
  end
  
  def update_multiple
    Translation.update(params[:translations].keys, params[:translations].values)
    T.set_all_cache(nil)
    @translations = Translation.find(params[:translations].keys)
    render :edit_multiple
  end

  # GET /translations/1/edit
  def edit
    @translation = Translation.find(params[:id])
  end

  # PUT /translations/1
  # PUT /translations/1.xml
  def update
    @translation = Translation.find(params[:id])

    respond_to do |format|
      if @translation.update_attributes(params[:translation])
        T.set_all_cache(nil)
        format.html { redirect_to(:translations, :notice => 'Translation was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @translation.errors, :status => :unprocessable_entity }
      end
    end
  end

end
