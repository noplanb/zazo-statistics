class VideosController < ApplicationController
  def new
    render text: "NOT IMPLEMENTED"
  end

  # Really should only be used for testing
  def new
    @video = Video.new
  end

  # POST
  def create
    video = Video.create!(user_id: params[:video][:user_id], file: params[:video][:file], receiver_id: params[:video][:receiver_id])
    logger.info("Uploaded file #{params[:video][:file].original_filename}")
  end

end
