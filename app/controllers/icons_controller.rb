class IconsController < ApplicationController
  before_filter :require_login
  skip_before_filter :require_login, :only => :show
  
  # GET /icons
  # GET /icons.json
  def index
    @icons = @current_user.icons

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @icons }
    end
  end

  # GET /icons/1
  # GET /icons/1.json
  def show
    logger.debug "#{params[:id]} into? #{@current_user.icon_ids}: #{@current_user.icon_ids.include? params[:id]}"
    if !params[:id].to_i.zero? and !@current_user.nil? and @current_user.icon_ids.include? params[:id].to_i
      @icon=Icon.find params[:id]
      user=@current_user
    elsif !@current_user.nil?
      @icon=@current_user.icons.random
      user=@current_user
    else
      user=User.find_by_username params[:id]
      @image=user.icons.random
    end
    send_data(@icon.blob.file,
              :type  => @icon.blob.content_type,
              :disposition => 'inline')
  end

  # GET /icons/new
  # GET /icons/new.json
  def new
    @icon = Icon.new
    @icon.user=@current_user
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @icon }
    end
  end
  
  # POST /icons
  # POST /icons.json
  def create
    @icon = Icon.new(params[:icon])

    respond_to do |format|
      if @icon.save
        format.html { redirect_to @icon, notice: 'Icon was successfully created.' }
        format.json { render json: @icon, status: :created, location: @icon }
      else
        format.html { render action: "new" }
        format.json { render json: @icon.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /icons/1
  # DELETE /icons/1.json
  def destroy
    @icon = Icon.find(params[:id])
    @icon.destroy

    respond_to do |format|
      format.html { redirect_to icons_url }
      format.json { head :no_content }
    end
  end
end
