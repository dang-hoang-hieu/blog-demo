class Comment < ActiveRecord::Base
	belongs_to :user
	belongs_to :entry
	validates :content,  presence: true, length: { maximum: 140}
	validates :user_id,  presence: true
	validates :entry_id, presence: true
	default_scope -> { order('created_at DESC') }
end
