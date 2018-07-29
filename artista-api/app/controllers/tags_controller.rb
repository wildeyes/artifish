class TagsController < ApplicationController
  skip_before_action :authorize_request

  # GET /tags.json
  def index
    @tags = Tag.all
  end
end
