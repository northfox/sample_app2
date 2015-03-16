class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') }

  before_save { generate_reply }
  
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }

  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships"\
                        " WHERE follower_id = :user_id"
    where("("\
          "user_id IN (#{followed_user_ids})"\
          " AND in_reply_to is null"\
          ")"\
          " OR user_id = :user_id"\
          " OR in_reply_to = :in_reply_to",
          user_id: user, in_reply_to: user.login_name)
  end

  private
    
    def generate_reply
      self.in_reply_to = self.content[/ @(.+)( |$)/, 1]
    end
end
