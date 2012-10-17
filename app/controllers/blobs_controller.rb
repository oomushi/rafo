class BlobsController < ApplicationController
  # GET /blobs
  # GET /blobs.json
  def index
    @blobs = Blob.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @blobs }
    end
  end

  # GET /blobs/1
  # GET /blobs/1.json
  def show
    @blob = Blob.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @blob }
    end
  end

  # GET /blobs/new
  # GET /blobs/new.json
  def new
    @blob = Blob.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @blob }
    end
  end

  # GET /blobs/1/edit
  def edit
    @blob = Blob.find(params[:id])
  end

  # POST /blobs
  # POST /blobs.json
  def create
    @blob = Blob.new(params[:blob])

    respond_to do |format|
      if @blob.save
        format.html { redirect_to @blob, notice: 'Blob was successfully created.' }
        format.json { render json: @blob, status: :created, location: @blob }
      else
        format.html { render action: "new" }
        format.json { render json: @blob.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /blobs/1
  # PUT /blobs/1.json
  def update
    @blob = Blob.find(params[:id])

    respond_to do |format|
      if @blob.update_attributes(params[:blob])
        format.html { redirect_to @blob, notice: 'Blob was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @blob.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blobs/1
  # DELETE /blobs/1.json
  def destroy
    @blob = Blob.find(params[:id])
    @blob.destroy

    respond_to do |format|
      format.html { redirect_to blobs_url }
      format.json { head :no_content }
    end
  end
end
