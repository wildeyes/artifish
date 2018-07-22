class CollectionsController < ApplicationController
  before_action :set_collection, only: [:show, :update, :destroy]

  # GET /collections
  def index
    @collections = current_user.collections
  end

  # GET /collections/1
  def show
  end

  # POST /collections
  def create
    @collection = current_user.collections.build(collection_params)

    if @collection.save
      render :show, status: :created
    else
      render json: @collection.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /collections/1
  def update
    if @collection.update(collection_params)
      render :show, status: :ok, location: @collection
    else
      render json: @collection.errors, status: :unprocessable_entity
    end
  end

  # DELETE /collections/1
  def destroy
    @collection.destroy
  end

  private
    def set_collection
      @collection = current_user.collections.find(params[:id])
    end

    def collection_params
      params.require(:collection).permit(:name).merge(params.permit(:workspace_image_contents))
    end
end
