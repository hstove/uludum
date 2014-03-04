class DownloadsController < ApplicationController
  before_action :set_downloadable
  load_and_authorize_resource through: :downloadable

  def index
    @downloads = @downloadable.downloads
  end
  # GET /downloads/1
  def show
    redirect_to @download.url
  end

  # GET /downloads/new
  def new
    @download = @downloadable.downloads.new
  end

  # GET /downloads/1/edit
  def edit
  end

  # POST /downloads
  def create
    @download = @downloadable.downloads.new(download_params)

    if @download.save
      redirect_to course_downloads_path(@download.course), notice: 'Download was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /downloads/1
  def update
    if @download.update(download_params)
      redirect_to course_downloads_path(@download.course), notice: 'Download was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /downloads/1
  def destroy
    @download.destroy
    redirect_to downloads_url, notice: 'Download was successfully destroyed.'
  end

  private

    def set_downloadable
      @downloadable = find_polymorphic(:downloads)
    end

    # Only allow a trusted parameter "white list" through.
    def download_params
      params.require(:download).permit(:url, :title, :description, :file_name, :file_type)
    end
end
