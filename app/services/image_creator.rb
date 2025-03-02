class ImageCreator
  attr_reader :image, :file_content

  def initialize(image, file_content)
    @image = image
    @file_content = file_content
  end

  def call
    if is_image?
      save_file
    else
      image.destroy
    end
  end

  private

  def is_image?
    mime_type.start_with?("image")
  end

  def extension
    @extension ||= file_ext.presence || file_content_ext
  end

  def file_ext
    @file_ext ||= File.extname(image.url)
  end

  def mime_type
    @mime_type ||= file_ext && Rack::Mime::MIME_TYPES[file_ext] || Marcel::MimeType.for(file_content)
  end

  def file_content_ext
    Rack::Mime::MIME_TYPES.invert[mime_type]
  end

  def save_file
    image.update_columns extension:
    File.open(image.reload.path, "wb") do |f|
      f << file_content
    end
    ImageConverter.new(image).call
    ImageMetadataUpdater.new(image.reload).call
    FindSimilarImage.new(image.reload).call
  end
end