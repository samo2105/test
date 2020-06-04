require "uri"
require "net/http"
require 'json'

api_key = "zRmHxGlSNlQ6k4ws3zkjRlPEQYp1RkwSRIQhmqDl"

def request(url, api)
  url = URI("#{url}&api_key=#{api}")
  https = Net::HTTP.new(url.host, url.port);
  https.use_ssl = true
  https.verify_mode = OpenSSL::SSL::VERIFY_PEER
  request = Net::HTTP::Get.new(url)
  response = https.request(request)
  JSON.parse response.read_body
end
  
photos = request("https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=10",api_key)

photos_url = photos["photos"].map { |photo| photo["img_src"] }

def build_web_page(photos)
  html = "<html> \n"
  html += "<head> \n"
  html += "</head> \n"
  html += "<body> \n"
  html += "<ul> \n"
  photos.each do |photo|
    html += "<li><img src='#{photo}'></li> \n"
  end
  html += "</ul> \n"
  html += "</body> \n"
  html += "</html> \n"
  File.write('output.html', html)
end

build_web_page(photos_url)


def photos_count(photos)
  counter = {} # Contador de fotos
  photos["photos"].each do |photo|
    camera = photo['camera']['full_name'] # Nombre de la cámara
    if counter.keys.include?(camera)
      counter[camera] += 1 # Suma uno al valor si ya existe dentro del hash
    else
      counter[camera] = 1 # Crea el valor dentro del hash 
    end
  end
  counter # Se coloca counter para el retorno
end 

puts photos_count(photos)

def photos_count2(photos)
  camera_counter = {}
  counter = photos['photos'].group_by {|photo| photo['camera']['full_name'] }
  counter.each {|k, v| camera_counter[k] = v.count }
  camera_counter
end

puts photos_count2(photos)