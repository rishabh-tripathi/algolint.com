class ContentsController < ApplicationController
  layout "blank"
  before_filter :check_credential, :except => []
  respond_to :html, :json
  # GET /contents
  # GET /contents.json
  def index
    if(params[:uid].present?)
      user = User.find_by_unique_key(params[:uid])
      if(user.present?)
        @contents = Content.find(:all, :conditions => ["user_id = ?", user.id])
        @contents += Content.find(:all, :conditions => ["template = ?", Content::TEMPLATE_AL]) 
      end
    else
      @contents = Content.all    
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @contents }
    end
  end

  # GET /contents/1
  # GET /contents/1.json
  def show
    @content = Content.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @content }
    end
  end

  # GET /contents/new
  # GET /contents/new.json
  def new
    @content = Content.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @content }
    end
  end

  # GET /contents/1/edit
  def edit
    @content = Content.find(params[:id])
  end

  # POST /contents
  # POST /contents.json
  def create
    @content = Content.new()
    @content.user_id = current_user.id
    @content.name = params[:name]
    @content.desc = params[:desc]
    @content.content = params[:content]
    @content.file_type = params[:file_type].to_i
    @content.compile = params[:compile].to_i
    @content.status = params[:status].to_i
    @content.sharability = params[:sharability].to_i       
    @content.template = params[:template].to_i       
    respond_to do |format|
      if(@content.save)
        current_user.last_open_file = @content.id
        current_user.save
        format.html { redirect_to @content, :notice => 'Content was successfully created.' }
        format.json { render :json => @content, :status => :created, :location => @content }
      else
        format.html { render :action => "new" }
        format.json { render :json => @content.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /contents/1
  # PUT /contents/1.json
  def update
    @content = Content.find(params[:id])
    @content.user_id = current_user.id
    @content.name = params[:name]
    @content.desc = params[:desc]
    @content.content = params[:content]
    @content.file_type = params[:file_type].to_i
    @content.compile = params[:compile].to_i
    @content.status = params[:status].to_i
    @content.sharability = params[:sharability].to_i       
    @content.template = params[:template].to_i       
    respond_to do |format|
      if(@content.save)
        current_user.last_open_file = @content.id
        current_user.save        
        format.html { redirect_to @content, :notice => 'Content was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @content.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /contents/1
  # DELETE /contents/1.json
  def destroy
    if(current_user.last_open_file == params[:id].to_i)
      current_user.last_open_file = nil
      current_user.save
    end
    @content = Content.find(params[:id])
    @content.destroy    
    respond_to do |format|
      format.html { redirect_to contents_url }
      format.json { head :no_content }
    end
  end
end
