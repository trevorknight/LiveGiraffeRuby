class ArtistsController < ApplicationController

  # GET /artists
  # GET /artists.xml
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
  end

  # GET /artists/1/edit
  def edit
    @artist = Artist.find(params[:id])
  end

  # POST /artists
  def create
    @artist = Artist.new(params[:artist])
	
    respond_to do |format|
      if @artist.save
        redirect_to new_event_path, :notice => 'Artist was successfully created.'
      else
        render :action => "new"
      end
    end
  end

  # PUT /artists/1
  def update
    @artist = Artist.find(params[:id])

    respond_to do |format|
      if @artist.update_attributes(params[:artist])
        redirect_to(@artist, :notice => 'Artist was successfully updated.')
      else
        render :action => "edit" 
      end
    end
  end

  # DELETE /artists/1
  def destroy
    @artist = Artist.find(params[:id])
    @artist.destroy

    respond_to do |format|
      redirect_to(artists_url)
    end
  end
end
