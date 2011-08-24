class CitiesController < ApplicationController
  sub_layout 'double'

  before_filter :fill_city, :only=>[:show, :edit, :destroy]

  def base_search
    q = params[:q].try(:downcase)
    cache_key = [:city_base_search, q]
    r = Rails.cache.read(cache_key)
    unless r
      r = render (q ? {:json => CityBase.search(q)} : {:json => []})
      Rails.cache.write(cache_key, r)
      puts "WROTE #{cache_key}"
    end
    r
  end

  def search
    q = params[:q].try(:downcase)
    cache_key = [:city_search, q]
    r = Rails.cache.read(cache_key)
    unless r
      r = render (q ? {:json => City.search(q)} : {:json => []})
      Rails.cache.write(cache_key, r)
      puts "WROTE #{cache_key}"
    end
    r
  end

  # GET /cities/1
  # GET /cities/1.xml
  def show
  end

  

  # GET /cities
  # GET /cities.xml
  def index
    @cities = City.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cities }
    end
  end

  # GET /cities/new
  # GET /cities/new.xml
  def new
    @city = City.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @city }
    end
  end

  # GET /cities/1/edit
  def edit
  end

  # POST /cities
  # POST /cities.xml
  def create
    @city = City.new(params[:city])

    respond_to do |format|
      if @city.save
        format.html { redirect_to(@city, :notice => 'City was successfully created.') }
        format.xml  { render :xml => @city, :status => :created, :location => @city }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @city.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cities/1
  # PUT /cities/1.xml
  def update
    @city = City.find(params[:id])

    respond_to do |format|
      if @city.update_attributes(params[:city])
        format.html { redirect_to(@city, :notice => 'City was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @city.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cities/1
  # DELETE /cities/1.xml
  def destroy
    @city.destroy

    respond_to do |format|
      format.html { redirect_to(cities_url) }
      format.xml  { head :ok }
    end
  end

  protected
  
  def fill_city
    if id = params[:city_id]||params[:id]
      @city = City.find(id)
    elsif label = params[:label]
      @city = City.findl(label)
    end
  end
end
