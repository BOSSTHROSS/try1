require 'nokogiri'
require 'open-uri'

class ImageFetcher

  EXCLUDES = [
    "http://a2.behance.net/img/site/grey.png"
  ]

  def self.get_all_img_src(url)
    doc = Nokogiri::HTML(open(url))
    imgs = doc.css('.module img').map do |img|
      img.attributes['src'].value
    end
    return imgs - EXCLUDES
  end

end

## Begin Main App

url = ARGV[0]
dir_path = ARGV[1] || "projects"

puts "Begin Download"
imgs = ImageFetcher.get_all_img_src(url)

puts "Create Folder"
project_path = File.join [dir_path, url.split('/')[-2]]
[dir_path, project_path].each do |dir|
  Dir.mkdir(dir) unless File.exists?(dir)
end

puts "Downloading Images"
imgs.each do |img|
  file_name = img.split('/').last
  file_path = File.join([project_path, file_name])
  content = open(img).read
  File.write(file_path, content)
end
