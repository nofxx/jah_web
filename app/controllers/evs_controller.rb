class EvsController < ApplicationController

  before_filter :load_resource, :only => [:show, :edit, :update, :destroy]
  before_filter :load_and_paginate_resources, :only => [:index]

  # GET /evs
  # GET /evs.js
  # GET /evs.xml
  # GET /evs.json
  def index
    respond_to do |format|
      format.html # index.html.haml
      format.js   # index.js.rjs
      format.xml  { render :xml => @evs }
      format.json  { render :json => @evs }
    end
  end

  # GET /evs/:id
  # GET /evs/:id.js
  # GET /evs/:id.xml
  # GET /evs/:id.json
  def show
    respond_to do |format|
      format.html # show.html.haml
      format.js   # show.js.rjs
      format.xml  { render :xml => @evs }
      format.json  { render :json => @evs }
    end
  end

  # GET /evs/new
  # GET /evs/new.js
  # GET /evs/new.xml
  # GET /evs/new.json
  def new
    @ev = Ev.new

    respond_to do |format|
      format.html # new.html.haml
      format.js   # new.js.rjs
      format.xml  { render :xml => @ev }
      format.json  { render :json => @ev }
    end
  end

  # GET /evs/:id/edit
  def edit
  end

  # POST /evs
  # POST /evs.js
  # POST /evs.xml
  # POST /evs.json
  def create
    @ev = Ev.new(params[:ev])

    respond_to do |format|
      if @ev.save
        flash[:notice] = "Ev was successfully created."
        format.html { redirect_to(@ev) }
        format.js   # create.js.rjs
        format.xml  { render :xml => @ev, :status => :created, :location => @ev }
        format.json  { render :json => @ev, :status => :created, :location => @ev }
      else
        flash[:error] = "Ev could not be created."
        format.html { render 'new' }
        format.js   # create.js.rjs
        format.xml  { render :xml => @ev.errors, :status => :unprocessable_entity }
        format.json  { render :json => @ev.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /evs/:id
  # PUT /evs/:id.js
  # PUT /evs/:id.xml
  # PUT /evs/:id.json
  def update
    respond_to do |format|
      if @ev.update_attributes(params[:ev])
        flash[:notice] = "Ev was successfully updated."
        format.html { redirect_to(@ev) }
        format.js   # update.js.rjs
        format.xml  { head :ok }
        format.json  { head :ok }
      else
        flash[:error] = "Ev could not be updated."
        format.html { render 'edit' }
        format.js   # update.js.rjs
        format.xml  { render :xml => @ev.errors, :status => :unprocessable_entity }
        format.json  { render :json => @ev.errors, :status => :unprocessable_entity }
      end
    end
  end

  def redo
    @ev = Ev.find(params[:id])


    if Ev.create(@ev.attributes.dup.merge(:created_at => nil))
      redirect_to(history_path)
    end
  end

  # DELETE /evs/:id
  # DELETE /evs/:id.js
  # DELETE /evs/:id.xml
  # DELETE /evs/:id.json
  def destroy
    respond_to do |format|
      if @ev.destroy
        flash[:notice] = "Ev was successfully destroyed."
        format.html { redirect_to(history_url) }
        format.js   # destroy.js.rjs
        format.xml  { head :ok }
        format.json  { head :ok }
      else
        flash[:error] = "Ev could not be destroyed."
        format.html { redirect_to(ev_url(@ev)) }
        format.js   # destroy.js.rjs
        format.xml  { head :unprocessable_entity }
        format.json  { head :unprocessable_entity }
      end
    end
  end

  protected

    def collection
      paginate_options ||= {}
      paginate_options[:page] ||= (params[:page] || 1)
      paginate_options[:per_page] ||= (params[:per_page] || 20)
      @collection = @evs ||= Ev.paginate(paginate_options)
    end
    alias :load_and_paginate_resources :collection

    def resource
      @resource = @ev ||= Ev.find(params[:id])
    end


    alias :load_resource :resource

end
