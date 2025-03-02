class ImagesController < ApplicationController
  before_action :set_image, only: %i[ show edit update destroy rate ]

  # GET /images or /images.json
  def index
    scope = Image
      .where.not(extension: [nil, ""])
      .where('rating >= ?', AppConfig.get("minrate"))
      .where('rating <= ?', AppConfig.get("maxrate"))
    @image = scope
      .order(:views, :rating, "random()").first
    @count = scope.count
    if @image.present?
      current_views = @image.views
      if current_views > 100
        Image.update_all("views = views - 90")
        @image.update_columns(views: current_views - 90 + 1)
      else
        @image.update_columns(views: current_views + 1)
      end
    end
  end

  def multiple
    @images = Image.where(id: params[:ids].split(","))
  end

  # GET /images/new
  def new
    @image = Image.new(regex: Rails.cache.read("image_regex"))
  end

  def rate
    @image.update_columns rating: params[:rating]
    redirect_to images_path
  end

  # GET /images/1/edit
  def edit
  end

  # POST /images or /images.json
  def create
    @image = Image.new(image_params)
    Rails.cache.write("image_regex", image_params[:regex])

    if @image.save
      CreateImageJob.perform_later(@image.id)
    end

    redirect_to new_image_path
  end

  # PATCH/PUT /images/1 or /images/1.json
  def update
    respond_to do |format|
      if @image.update(image_params)
        format.html { redirect_to @image, notice: "Image was successfully updated." }
        format.json { render :show, status: :ok, location: @image }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1 or /images/1.json
  def destroy
    @image.destroy!

    respond_to do |format|
      format.html { redirect_to images_path, status: :see_other, notice: "Image was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def reset
    Image.update_all(views: 0)
    redirect_to images_path
  end

  def set_config
    AppConfig.increment(params[:name], cascading: true)
    redirect_to images_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @image = Image.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def image_params
      params.expect(image: [ :url, :rating, :regex ])
    end
end
