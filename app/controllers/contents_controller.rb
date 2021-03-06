class ContentsController < ApplicationController
  layout "blank"
  before_filter :check_credential, :except => []
  respond_to :html, :json
  
  # GET /contents
  # GET /contents.json
  def index
    if(params[:uid].present? || params[:cli].present?)
      if(params[:cli].present?)
        user = current_user
      else
        user = User.find_by_unique_key(params[:uid])
      end
      if(user.present?)
        @contents = Content.find(:all, :conditions => ["user_id = ?", user.id])
        if(params[:temp].present?)          
          templates = Content.find(:all, :conditions => ["template = ?", Content::TEMPLATE_AL]) 
          templates += Content.find(:all, :conditions => ["template = ? and user_id = ?", Content::TEMPLATE_USER, user.id]) 
          @contents = templates
        else
          templates = Content.find(:all, :conditions => ["template = ?", Content::TEMPLATE_AL]) 
          @contents += templates
        end
      end
    else
      @contents = Content.all    
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { 
        if(params[:cli].present?)
          output = []
          if(params[:temp].present?)
            for c in @contents
              output << "'#{c.name}' by #{(c.template == Content::TEMPLATE_AL)? 'Algolint' : 'You'}"
            end
            op = (output.present?)? output.join("\n") : ""             
          else
            for c in @contents
              output << "#{c.id}:#{c.name}"
            end
            op = (output.present?)? output.join(";") : "" 
          end
          render :text => op
        else
          render :json => @contents 
        end
      }
    end
  end

  # GET /contents/1
  # GET /contents/1.json
  def show
    @content = Content.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { 
        if(params[:cli].present?)
          render :text => @content.get_final_code
        else
          render :json => @content 
        end
      }
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
    @content.template = params[:template].to_i if(params[:template].present? && (params[:template].to_i != -10))      
    @content.folder_id = params[:folder_id].to_i if(params[:folder_id].present?)
    if(params[:tempname].present?)      
      temp = Content.find(:first, :conditions => ["template = ? and user_id = ? and name = ?", Content::TEMPLATE_USER, current_user.id, params[:tempname]]) 
      if(temp.nil?)
        temp = Content.find(:first, :conditions => ["template = ? and name = ?", Content::TEMPLATE_AL, params[:tempname]]) 
      end      
      if(!temp.nil?)
        @content.content = temp.content
      end
    end
    respond_to do |format|
      if(@content.save)
        current_user.last_open_file = @content.id
        current_user.save
        format.html { redirect_to @content, :notice => 'Content was successfully created.' }
        format.json { 
          if(params[:cli].present?)
            render :text => @content.id
          else
            render :json => @content, :status => :created, :location => @content         
          end
        }
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
    @content.status = params[:status].to_i if(params[:status].present?)
    @content.sharability = params[:sharability].to_i       
    @content.template = params[:template].to_i if(params[:template].present? && (params[:template].to_i != -10))             
    @content.folder_id = params[:folder_id].to_i if(params[:folder_id].present?)
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
