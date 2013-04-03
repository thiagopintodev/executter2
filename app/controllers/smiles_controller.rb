class SmilesController < ApplicationController
  # GET /smiles
  # GET /smiles.xml
  def index
    @smiles = Smile.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @smiles }
    end
  end

  # GET /smiles/1
  # GET /smiles/1.xml
  def show
    @smile = Smile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @smile }
    end
  end

  # GET /smiles/new
  # GET /smiles/new.xml
  def new
    @smile = Smile.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @smile }
    end
  end

  # GET /smiles/1/edit
  def edit
    @smile = Smile.find(params[:id])
  end

  # POST /smiles
  # POST /smiles.xml
  def create
    @smile = Smile.new(params[:smile])

    respond_to do |format|
      if @smile.save
        format.html { redirect_to(@smile, :notice => 'Smile was successfully created.') }
        format.xml  { render :xml => @smile, :status => :created, :location => @smile }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @smile.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /smiles/1
  # PUT /smiles/1.xml
  def update
    @smile = Smile.find(params[:id])

    respond_to do |format|
      if @smile.update_attributes(params[:smile])
        format.html { redirect_to(@smile, :notice => 'Smile was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @smile.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /smiles/1
  # DELETE /smiles/1.xml
  def destroy
    @smile = Smile.find(params[:id])
    @smile.destroy

    respond_to do |format|
      format.html { redirect_to(smiles_url) }
      format.xml  { head :ok }
    end
  end
end
