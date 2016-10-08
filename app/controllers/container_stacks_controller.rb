class ContainerStacksController < ApplicationController
  # GET /container_stacks
  # GET /container_stacks.json
  def index
    @container_stacks = ContainerStack.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @container_stacks }
    end
  end

  # GET /container_stacks/1
  # GET /container_stacks/1.json
  def show
    @container_stack = ContainerStack.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @container_stack }
    end
  end

  # GET /container_stacks/new
  # GET /container_stacks/new.json
  def new
    @container_stack = ContainerStack.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @container_stack }
    end
  end

  # GET /container_stacks/1/edit
  def edit
    @container_stack = ContainerStack.find(params[:id])
  end

  # POST /container_stacks
  # POST /container_stacks.json
  def create
    @container_stack = ContainerStack.new(params[:container_stack])

    respond_to do |format|
      if @container_stack.save
        format.html { redirect_to @container_stack, notice: 'Container stack was successfully created.' }
        format.json { render json: @container_stack, status: :created, location: @container_stack }
      else
        format.html { render action: "new" }
        format.json { render json: @container_stack.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /container_stacks/1
  # PUT /container_stacks/1.json
  def update
    @container_stack = ContainerStack.find(params[:id])

    respond_to do |format|
      if @container_stack.update_attributes(params[:container_stack])
        format.html { redirect_to @container_stack, notice: 'Container stack was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @container_stack.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /container_stacks/1
  # DELETE /container_stacks/1.json
  def destroy
    @container_stack = ContainerStack.find(params[:id])
    @container_stack.destroy

    respond_to do |format|
      format.html { redirect_to container_stacks_url }
      format.json { head :no_content }
    end
  end
end
