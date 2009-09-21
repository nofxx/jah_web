class ProksController < ApplicationController

  before_filter :load_prok, :only => [:show, :destroy]

  # GET /hosts/:id/proks
  def index
    host = Host.find(params[:host_id])
    @proks = host.proks.all

    respond_to do |format|
      format.html # index.html.haml
      format.js   # index.js.rjs
      format.xml  { render :xml => @evs }
      format.json  { render :json => @evs }
    end
  end

  # GET /hosts/:id/proks/:id
  def destroy
    if @prok.kill!
      flash[:notice] = "Prok killed.."
      redirect_to(@host)
    else
      redirect_to(@host)
    end
  end



  protected



  def load_prok
    @host = Host.find(params[:host_id])
    @prok = @host.find_prok(params[:id])
  end


end
