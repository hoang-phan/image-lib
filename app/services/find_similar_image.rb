class FindSimilarImage
  attr_reader :image

  OFFSETS = {
    size: 0.1,
    k_val: 0.1,
    avg_r: 0.1,
    avg_g: 0.1,
    avg_b: 0.1,
    avg_a: 0.1
  }

  DIFF_THRESHOLD = 1000

  def initialize(image)
    @image = image
  end

  def call
    similar = nil

    images_scope.find_each do |img|
      diff = `compare -metric RMSE #{image.path} #{img.path} NULL 2>&1`.strip.to_f
      
      if diff <= DIFF_THRESHOLD
        similar = img
        break
      end
    end

    if similar
      image.update_columns similar_ids:
    end
  end

  private

  def images_scope
    scope = Image.where.not(id: image.id).where(width: image.width, height: image.height)
    OFFSETS.each do |key, offset_rate|
      value = image[key]
      offset = offset_rate * value
      scope = scope.where(key => (value - offset)..(value + offset))
    end
    scope
  end
end