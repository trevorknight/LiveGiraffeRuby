class ArtistsController < ApplicationController
  before_filter :authenticate, :except => [:index, :show]


  # GET /artists

  def index
    @artists = Artist.where("name LIKE ?", "%#{params[:q]}%")

    respond_to do |format|
      format.html # index.html.erb
	    format.json { render :json => @artists }
    end
  end

  # GET /artists/1
  def show
    @artist = Artist.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /artists/new
  def new
    @artist = Artist.new
    
    respond_to do |format|
      format.html #new.html.erb
    end
  end

  # GET /artists/1/edit
  def edit
    @artist = current_user.artists.find(params[:id])
  end

  # POST /artists
  def create
    @artist = current_user.artists.new(params[:artist])
	
    respond_to do |format|
      if @artist.save
        format.html { redirect_to(new_event_path, :notice => t('controllers.artists.created')) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /artists/1
  def update
    @artist = current_user.artists.find(params[:id])
    respond_to do |format|
      if @artist.update_attributes(params[:artist])
        format.html { redirect_to(@artist, :notice => t('controllers.artists.updated')) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /artists/1
  def destroy
    @artist = current_user.artists.find(params[:id])
    @artist.destroy
    respond_to do |format|
      format.html { redirect_to(artists_url) }
    end
  end
end