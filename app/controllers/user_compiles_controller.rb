class UserCompilesController < ApplicationController
  # GET /user_compiles
  # GET /user_compiles.json
  def index
    @user_compiles = UserCompile.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_compiles }
    end
  end

  # GET /user_compiles/1
  # GET /user_compiles/1.json
  def show
    @user_compile = UserCompile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user_compile }
    end
  end

  # GET /user_compiles/new
  # GET /user_compiles/new.json
  def new
    @user_compile = UserCompile.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_compile }
    end
  end

  # GET /user_compiles/1/edit
  def edit
    @user_compile = UserCompile.find(params[:id])
  end

  # POST /user_compiles
  # POST /user_compiles.json
  def create
    @user_compile = UserCompile.new(params[:user_compile])

    respond_to do |format|
      if @user_compile.save
        format.html { redirect_to @user_compile, notice: 'User compile was successfully created.' }
        format.json { render json: @user_compile, status: :created, location: @user_compile }
      else
        format.html { render action: "new" }
        format.json { render json: @user_compile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /user_compiles/1
  # PUT /user_compiles/1.json
  def update
    @user_compile = UserCompile.find(params[:id])

    respond_to do |format|
      if @user_compile.update_attributes(params[:user_compile])
        format.html { redirect_to @user_compile, notice: 'User compile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_compile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_compiles/1
  # DELETE /user_compiles/1.json
  def destroy
    @user_compile = UserCompile.find(params[:id])
    @user_compile.destroy

    respond_to do |format|
      format.html { redirect_to user_compiles_url }
      format.json { head :no_content }
    end
  end
end
