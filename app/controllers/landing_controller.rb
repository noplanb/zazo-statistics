class LandingController < ApplicationController
  include LandingHelper # FIXME: should be included automatically

  layout 'landing'
  before_action :set_state

  def index
    render :invite
  end

  def invite
    return if windows_phone?
    redirect_to iphone_store_url if ios?
    redirect_to android_store_url if android?
  end

  def privacy
  end

  def ios_coming_soon
  end

  private

  def set_state
    @inviter = params[:id] && User.where(mkey: params[:id]).first
  end
end
