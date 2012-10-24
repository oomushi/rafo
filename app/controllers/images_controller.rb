class ImagesController < ApplicationController
  before_filter :require_login
  skip_before_filter :require_login, :only => :show
  # GET /images
  # GET /images.json
  def index
    @images = @current_user.images
    @images.each do |i|
      i.text=@current_user.quotes.random
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @images }
    end
  end

  # GET /images/1
  # GET /images/1.json
  def show
    if !params[:id].to_i.zero? and !@current_user.nil? and @current_user.image_ids.include? params[:id].to_i
      @image=Image.find params[:id]
      user=@current_user
    elsif !@current_user.nil?
      @image=@current_user.images.random
      user=@current_user
    else
      user=User.find_by_username params[:id]
      @image=user.images.random
    end
    @image.text=user.quotes.random
    send_data(@image.to_img,
              :type  => 'image/png',
              :disposition => 'inline')
  end

  # GET /images/new
  # GET /images/new.json
  def new
    @image = Image.new
    @image.user=@current_user
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @image }
    end
  end

  # POST /images
  # POST /images.json
  def create
    @image = Image.new(params[:image])

    respond_to do |format|
      if @image.save
        format.html { redirect_to images_url, notice: 'Image was successfully created.' }
        format.json { render json: @image, status: :created, location: @image }
      else
        format.html { redirect_to images_url }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    @image = Image.find(params[:id])
    @image.destroy

    respond_to do |format|
      format.html { redirect_to images_url }
      format.json { head :no_content }
    end
  end
end
