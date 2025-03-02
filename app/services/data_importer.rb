require 'zip'

class DataImporter
  def call
    drive = Google::Apis::DriveV3::DriveService.new
    drive.authorization = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: File.open('./google-api.json'),
      scope: "https://www.googleapis.com/auth/drive"
    )

    drive.list_files.files.each do |file|
      filename = file.name
      rating = filename.split('-')[1]
      records = []

      # drive.get_file(file.id, download_dest: file.name)
      Zip::File.open(filename) do |zip|
        zip.each do |entry|
          id = File.basename(entry.name, '.jpg')
          Image.create(id:, url: id, extension: '.jpg', rating:)
        end
      end

      `unzip -P ImageLib #{filename}`
    end

    `rm -rf imagelib-*.zip`
  end
end