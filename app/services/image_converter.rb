class ImageConverter
  attr_reader :image

  def initialize(image)
    @image = image
  end

  def call
    return if image.extension == ".jpg"

    `convert #{image.path} files/#{image.id}.jpg`
    FileUtils.rm_rf(image.path)

    image.update_columns extension: ".jpg"
  end
end