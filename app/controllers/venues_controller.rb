class VenuesController < ApplicationController
  before_filter :authenticate, :except => [:index, :show]


  # GET /venues
  def index
	@venues = Venue.where("name LIKE ?", "%#{params[:q]}%")
    
	respond_to do |format|
      format.html # index.html.erb
  	  format.json { render :json => @venues }
    end
  end

  # GET /venues/1
  def show
    @venue = Venue.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /venues/new
  def new
    @venue = Venue.new

    respond_to do |format|
      format.html # new.html.erb
      #format.xml  { render :xml => @venue }
    end
  end

  # GET /venues/1/edit
  def edit
    @venue = current_user.venues.find(params[:id])
  end

  # POST /venues
  def create
    @venue = current_user.venues.new(params[:venue])

    respond_to do |format|
      if @venue.save
        format.html { redirect_to(new_event_path, :notice => t('controllers.venues.created')) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /venues/1
  def update
    @venue = current_user.venues.find(params[:id])

    respond_to do |format|
      if @venue.update_attributes(params[:venue])
        format.html { redirect_to(@venue, :notice => t('controllers.venues.updated')) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /venues/1
  def destroy
    @venue = current_user.venues.find(params[:id])
    @venue.destroy

    respond_to do |format|
      format.html { redirect_to(venues_url) }
    end
  end
end
