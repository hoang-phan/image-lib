require 'open-uri'

class CreateImageJob < ApplicationJob
  def perform(id)
    image = Image.find(id)
    file_content = URI.open(image.url).read

    image_urls = image.regex.present? ? file_content.scan(Regexp.new(image.regex)) : []

    if image_urls.present?
      image_urls.each do |url|
        new_image = Image.new(url:)
        if new_image.save
          CreateImageJob.perform_later(new_image.id)
        end
      end
      image.destroy
    else
      ImageCreator.new(image, file_content).call
    end
  end
end
