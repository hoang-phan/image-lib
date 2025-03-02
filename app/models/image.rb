class Image < ApplicationRecord
	validates :url, presence: true, uniqueness: true
	before_destroy :remove_image

	def path
		"files/#{id}#{extension}"
	end

	private

	def remove_image
		FileUtils.rm_rf(path)
	end
end
