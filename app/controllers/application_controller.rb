class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  REALM = 'zazo.com'

  attr_reader :current_user
  helper_method :current_user

  # ==================
  # = Before filters =
  # ==================
  def authenticate_with_digest
    authenticate_or_request_with_http_digest(REALM) do |mkey|
      @user = @current_user = User.find_by_mkey(mkey)
      @user && @user.auth
    end
  end

  def authenticate_with_token
    authenticate_with_http_token do |token, options|
      @user = @current_user = User.find_by_mkey(token)
      @user && @user.auth
    end
  end

  def authenticate
    if Settings.allow_authentication_with_token
      authenticate_with_token || authenticate_with_digest
    else
      authenticate_with_digest
    end
  end

  def notify_error(error)
    Rollbar.error(error)
  end

  def not_found
    fail ActionController::RoutingError.new('Not Found')
  end

  # FIXME: Alex, this is ugly cuz it is redundant with landing helper. Please fix. Isnt there a way to make the methods in
  # controller be available to views automatically. Anyway the ones related to type of request are pretty broadly useful
  # methods so probably shouldnt be down in landingHelper. Please clean as you see fit. I just wanted to make it work
  # since iphone is now in the store.

  def mobile_device?
    request.user_agent =~ /mobile|webos/i
  end

  def android?
    request.user_agent =~ /android/i
  end

  def ios?
    request.user_agent =~ /ios|iphone|ipad/i
  end

  def iphone_store_url
    Settings.iphone_store_url
  end

  def android_store_url
    Settings.android_store_url
  end

  def store_url
    ios? ? iphone_store_url : android_store_url
  end

  def notify_video_received(push_user, sender_mkey, video_id)
    video_filename = Kvstore.video_filename(sender_mkey,
                                            push_user.mkey,
                                            video_id)
    EventDispatcher.emit('video:notification:received',
                         initiator: 'user',
                         initiator_id: push_user.mkey,
                         target: 'video',
                         target_id: video_filename,
                         data: {
                           sender_id: sender_mkey,
                           receiver_id: push_user.mkey,
                           video_filename: video_filename,
                           video_id: video_id
                         },
                         raw_params: params.except(:controller, :action))
  end

  def send_video_received_notification(push_user, sender_mkey, sender_name, video_id)
    notify_video_received(push_user, sender_mkey, video_id)
    @push_user.send_notification(type: :alert,
                                 alert: "New message from #{sender_name}",
                                 badge: 1,
                                 payload: { type: 'video_received',
                                            from_mkey: sender_mkey,
                                            video_id: video_id,
                                            host: request.host })
  end

end
