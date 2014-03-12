class Entry < ActiveRecord::Base
	belongs_to :user
	has_many :comments, dependent: :destroy
	validates :user_id, presence: true
	validates :body, presence: true	
	validates :title, presence: true, length: { maximum: 200}
	default_scope -> { order('created_at DESC') }

	def self.from_users_followed_by(user)
		followed_user_ids = " SELECT followed_id FROM relationships WHERE follower_id = :follower_id"
		where(" user_id IN (#{followed_user_ids}) or user_id = (:follower_id)", follower_id: user)
	end
end
