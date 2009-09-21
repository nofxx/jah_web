class HistoryController < ApplicationController

  def index
    @h = Ev.search(params[:search], params[:page] )

  end


end
