class ImageConfigsController < ApplicationController
  # GET /image_configs
  # GET /image_configs.json
  def index
    @image_configs = ImageConfig.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @image_configs }
    end
  end

  # GET /image_configs/1
  # GET /image_configs/1.json
  def show
    @image_config = ImageConfig.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @image_config }
    end
  end

  # GET /image_configs/new
  # GET /image_configs/new.json
  def new
    @image_config = ImageConfig.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @image_config }
    end
  end

  # GET /image_configs/1/edit
  def edit
    @image_config = ImageConfig.find(params[:id])
  end

  # POST /image_configs
  # POST /image_configs.json
  def create
    @image_config = ImageConfig.new(params[:image_config])

    respond_to do |format|
      if @image_config.save
        format.html { redirect_to @image_config, notice: 'Image config was successfully created.' }
        format.json { render json: @image_config, status: :created, location: @image_config }
      else
        format.html { render action: "new" }
        format.json { render json: @image_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /image_configs/1
  # PUT /image_configs/1.json
  def update
    @image_config = ImageConfig.find(params[:id])

    respond_to do |format|
      if @image_config.update_attributes(params[:image_config])
        format.html { redirect_to @image_config, notice: 'Image config was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @image_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /image_configs/1
  # DELETE /image_configs/1.json
  def destroy
    @image_config = ImageConfig.find(params[:id])
    @image_config.destroy

    respond_to do |format|
      format.html { redirect_to image_configs_url }
      format.json { head :no_content }
    end
  end
end
