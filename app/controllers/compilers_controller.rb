class CompilersController < ApplicationController
  # GET /compilers
  # GET /compilers.json
  def index
    @compilers = Compiler.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @compilers }
    end
  end

  # GET /compilers/1
  # GET /compilers/1.json
  def show
    @compiler = Compiler.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @compiler }
    end
  end

  # GET /compilers/new
  # GET /compilers/new.json
  def new
    @compiler = Compiler.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @compiler }
    end
  end

  # GET /compilers/1/edit
  def edit
    @compiler = Compiler.find(params[:id])
  end

  # POST /compilers
  # POST /compilers.json
  def create
    @compiler = Compiler.new(params[:compiler])

    respond_to do |format|
      if @compiler.save
        format.html { redirect_to @compiler, notice: 'Compiler was successfully created.' }
        format.json { render json: @compiler, status: :created, location: @compiler }
      else
        format.html { render action: "new" }
        format.json { render json: @compiler.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /compilers/1
  # PUT /compilers/1.json
  def update
    @compiler = Compiler.find(params[:id])

    respond_to do |format|
      if @compiler.update_attributes(params[:compiler])
        format.html { redirect_to @compiler, notice: 'Compiler was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @compiler.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /compilers/1
  # DELETE /compilers/1.json
  def destroy
    @compiler = Compiler.find(params[:id])
    @compiler.destroy

    respond_to do |format|
      format.html { redirect_to compilers_url }
      format.json { head :no_content }
    end
  end
end
