class FestivalsController < ApplicationController

# GET festivals/1
  def show
    @festival = Festival.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      #format.xml  { render :xml => @event }
    end
  end
  
end