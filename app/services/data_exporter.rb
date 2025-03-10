class DataExporter
  BATCH_SIZE = 100

  def call(min: 3, max: 5)
    drive = Google::Apis::DriveV3::DriveService.new
    drive.authorization = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: File.open('./google-api.json'),
      scope: "https://www.googleapis.com/auth/drive"
    )

    max.downto(min) do |rating|
      offset = 0

      while true
        paths = Image.where(rating:).order(:id).offset(offset).limit(BATCH_SIZE).map(&:path).join(' ')
        break if paths.blank?
        filename = "imagelib-#{rating}-#{offset}.zip"
        `zip -P #{ENV['ZIP_PASSWORD']} #{filename} #{paths}`
        metadata = Google::Apis::DriveV3::File.new(name: filename)
        metadata = drive.create_file(metadata, upload_source: filename, content_type: 'application/zip')
        offset += BATCH_SIZE
      end
    end

    `rm -rf imagelib-*.zip`
  end
end