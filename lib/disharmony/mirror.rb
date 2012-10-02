require 'net/http'
require 'fog'
require 'uri'
require 'json'

class Disharmony::Mirror
  attr_accessor :attributes, :show, :storage, :net

  def initialize(show)
    config = Disharmony::Config['mirror']

    self.show = show
    self.attributes = show.attributes
    uri = URI.parse(config['url'])
    self.net = Net::HTTP.new(uri.host, uri.port)

    connection = Fog::Storage.new({
      :aws_access_key_id      => config['access'],
      :aws_secret_access_key  => config['secret'],
      :provider               => config['provider'],
      :region => config['region'] 
    })

    self.storage = connection.directories.get(config['directory']) 
  end

  def post!
    upload_to_s3
    post_to_mirror
    self.show.mirrored!
  end

  private
  def upload_to_s3
    file = self.storage.files.create({
      :key => show.mp3,
      :body => File.open(self.show.path),
      :public => true,
      :multipart_chunk_size => 5242880
    })
    #puts file.public_url
    self.attributes['url'] = file.public_url
  end

  def post_to_mirror
    request = Net::HTTP::Post.new('/shows')
    request.content_type = 'application/json'
    request.body = self.attributes.to_json

    response = self.net.start do |http|
      http.request(request)
    end
    
    #puts response.code
    #puts response.read_body
  end
end
