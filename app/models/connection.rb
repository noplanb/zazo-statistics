require 'no_plan_b/utils/text_utils'

class Connection < ActiveRecord::Base
  include EnumHandler

  belongs_to :creator, class_name: 'User'
  belongs_to :target, class_name: 'User'

  validates :creator_id, :target_id, :status, presence: true, on: :create

  before_create :check_for_dups

  after_create :set_ckey

  define_enum :status, [:established, :voided],
              sets: {
                live: [:established]
              },
              primary: true

  scope :for_user_id, ->(user_id) { where ['creator_id = ? OR target_id = ?', user_id, user_id] }
  scope :between_creator_and_target, ->(creator_id, target_id) { where ['creator_id = ? AND target_id = ?', creator_id, target_id] }

  def self.live_between(user1_id, user2_id)
    between_creator_and_target(user1_id, user2_id).live + between_creator_and_target(user2_id, user1_id).live
  end

  def self.between(user1_id, user2_id)
    between_creator_and_target(user1_id, user2_id) + between_creator_and_target(user2_id, user1_id)
  end

  def self.find_or_create(creator_id, target_id)
    between(creator_id, target_id).first || create(creator_id: creator_id, target_id: target_id, status: :established)
  end

  def check_for_dups
    unless Connection.live_between(creator_id, target_id).blank?
      fail "Cannot create a connection between #{creator_id} and #{target_id} a live one already exists."
    end
  end

  def set_ckey
    self.ckey = "#{creator_id}_#{target_id}_#{NoPlanB::TextUtils.random_string(20)}" if ckey.blank?
    save
  end

  def active?
    return false if status != :established
    Kvstore.where(key1: self.class.kvstore_key(creator, target, self)).count > 0 &&
      Kvstore.where(key1: self.class.kvstore_key(target, creator, self)).count > 0
  end

  def self.kvstore_key(sender, receiver, connection)
    "#{sender.mkey}-#{receiver.mkey}-#{connection.ckey}-VideoIdKVKey"
  end

  def self.add_remote_key(sender, receiver, video_id)
    connection = live_between(sender.id, receiver.id).first
    fail 'no live connections found' if connection.nil?
    params = {}
    params[:key1] = kvstore_key(sender, receiver, connection)
    params[:key2] = video_id
    params[:value] = { 'videoId' => video_id }.to_json
    Kvstore.create_or_update(params)
  end

  def self.video_filename(sender, receiver, video_id)
    connection = live_between(sender.id, receiver.id).first
    "#{sender.mkey}-#{receiver.mkey}-#{Digest::MD5.new.update(connection.ckey + video_id).hexdigest}"
  end
end
