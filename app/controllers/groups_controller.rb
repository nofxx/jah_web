class GroupsController < ApplicationController

  before_filter :load_resource, :only => [:show, :edit, :update, :destroy]
  before_filter :load_and_paginate_resources, :only => [:index]

  # GET /groups
  # GET /groups.js
  # GET /groups.xml
  # GET /groups.json
  def index
    respond_to do |format|
      format.html # index.html.haml
      format.js   # index.js.rjs
      format.xml  { render :xml => @groups }
      format.json  { render :json => @groups }
    end
  end

  # GET /groups/:id
  # GET /groups/:id.js
  # GET /groups/:id.xml
  # GET /groups/:id.json
  def show
    respond_to do |format|
      format.html # show.html.haml
      format.js   # show.js.rjs
      format.xml  { render :xml => @groups }
      format.json  { render :json => @groups }
    end
  end

  # GET /groups/new
  # GET /groups/new.js
  # GET /groups/new.xml
  # GET /groups/new.json
  def new
    @group = Group.new

    respond_to do |format|
      format.html # new.html.haml
      format.js   # new.js.rjs
      format.xml  { render :xml => @group }
      format.json  { render :json => @group }
    end
  end

  # GET /groups/:id/edit
  def edit
  end

  # POST /groups
  # POST /groups.js
  # POST /groups.xml
  # POST /groups.json
  def create
    @group = Group.new(params[:group])

    respond_to do |format|
      if @group.save
        flash[:notice] = "Group was successfully created."
        format.html { redirect_to(groups_path) }
        format.js   # create.js.rjs
        format.xml  { render :xml => @group, :status => :created, :location => @group }
        format.json  { render :json => @group, :status => :created, :location => @group }
      else
        flash[:error] = "Group could not be created."
        format.html { render 'new' }
        format.js   # create.js.rjs
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
        format.json  { render :json => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /groups/:id
  # PUT /groups/:id.js
  # PUT /groups/:id.xml
  # PUT /groups/:id.json
  def update
    respond_to do |format|
      if @group.update_attributes(params[:group])
        flash[:notice] = "Group was successfully updated."
        format.html { redirect_to(@group) }
        format.js   # update.js.rjs
        format.xml  { head :ok }
        format.json  { head :ok }
      else
        flash[:error] = "Group could not be updated."
        format.html { render 'edit' }
        format.js   # update.js.rjs
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
        format.json  { render :json => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/:id
  # DELETE /groups/:id.js
  # DELETE /groups/:id.xml
  # DELETE /groups/:id.json
  def destroy
    respond_to do |format|
      if @group.destroy
        flash[:notice] = "Group was successfully destroyed."
        format.html { redirect_to(groups_url) }
        format.js   # destroy.js.rjs
        format.xml  { head :ok }
        format.json  { head :ok }
      else
        flash[:error] = "Group could not be destroyed."
        format.html { redirect_to(group_url(@group)) }
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
      @collection = @groups ||= Group.paginate(paginate_options)
    end
    alias :load_and_paginate_resources :collection

    def resource
      @resource = @group ||= Group.find(params[:id])
    end
    alias :load_resource :resource

end
