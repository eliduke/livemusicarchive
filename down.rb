require 'fileutils'
require 'nokogiri'
require 'open-uri'
require 'down'

BASE_HOST = 'https://www.blueheron.video'.freeze

(71..208).to_a.each do |object_id|
  object_type = "VENUE"
  object_url = "https://www.blueheron.video/venues/#{object_id}"

  # 1. Fetch band webpage
  puts "==> Fetching #{object_type}: #{object_url}"
  begin
    doc = Nokogiri::HTML(URI.open object_url)
  rescue OpenURI::HTTPError
    puts "==> ERROR: #{object_type} DOES NOT EXIST: #{object_id}"
    puts
    next
  end

  # 2. Make folders
  folder_path = "images/venues"
  # Make folders if they don't exist
  FileUtils.mkdir_p folder_path
  # Make absolute file path for later downloads
  destination_path = [FileUtils.pwd, folder_path].join '/'

  puts "==> #{destination_path}"

  # ---------------------

  # 6. Find downloads in webpage
  # Find its downloads in head link tags
  puts "==> Finding image"
  image_path = doc.css('img').attr('src').value

  if image_path.include? 'placeskull'
    puts "==> No image for #{object_type} #{object_id}"
    puts
    next
  end

  download_url = BASE_HOST + image_path

  # ---------------------

  # 7. Download image into band folder
  extension                 = download_url.split('.').last
  download_destination_path = [destination_path, '/', object_id, ".#{extension}"].join

  puts "==> #{extension.upcase}"

  if File.exist? download_destination_path
    puts "==> #{extension.upcase} already downloaded, skipping"
  else
    puts "==> Downloading #{download_url}"
    puts "==> Saving to #{destination_path}"

    begin
      Down.download download_url, destination: download_destination_path
    rescue Errno::ENOENT
      puts "==> ERROR: UNKNOWN IMAGE FOR #{object_type} #{object_id}"
      puts
      next
    end
  end
  puts
  puts
end
