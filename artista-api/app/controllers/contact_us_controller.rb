class ContactUsController < ApplicationController
  skip_before_action :authorize_request

  def create
    raise ExceptionHandler::BadRequest, Message.missing_parameter(:name) if params[:name].blank?
    raise ExceptionHandler::BadRequest, Message.missing_parameter(:email) if params[:email].blank?
    raise ExceptionHandler::BadRequest, Message.missing_parameter(:title) if params[:title].blank?
    raise ExceptionHandler::BadRequest, Message.missing_parameter(:message) if params[:message].blank?

    ContactUsMailer.contact_us(params).deliver
  end

end
