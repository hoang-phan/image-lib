class ImageMetadataUpdater
  attr_reader :image

  def initialize(image)
    @image = image
  end

  def call
    k_val, width, height = `convert #{image.path} -format "%k %w %h" info:`.split(" ")
    avg_r, avg_g, avg_b, avg_a = `convert #{image.path} -resize 1x1 -format "#{avg_format}" info:-`.split(" ")
    size = File.size(image.path)
    image.update_columns size:, k_val:, width:, height:, avg_r:, avg_g:, avg_b:, avg_a:
  end

  private

  def avg_format
    %w[r g b a].map do |attr|
      "%[fx:int(255*#{attr}+.5)]"
    end.join(" ")
  end
end