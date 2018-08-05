class MaterialsController < ApplicationController
  skip_before_action :authorize_request

  # GET /tags.json
  def index
    @materials = Material.all
  end
end
