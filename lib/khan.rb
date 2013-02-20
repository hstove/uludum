class Khan
  include HTTParty
  base_uri 'http://khanacademy.org'
  ssl_ca_file('/opt/local/share/curl/curl-ca-bundle.crt') if File.exists?('/opt/local/share/curl/curl-ca-bundle.crt')

  def library
    response = self.class.get "/api/v1/playlists/library"
    JSON.parse response.body
  end

  def description_for_course course
    url = "/science/#{slug(course.category)}/#{slug(course.title)}"
    ap url
    response = self.class.get url
    d = nil
    doc = Nokogiri::HTML(response.body)
    _desc = doc.css('.topic-desc')
    unless _desc.empty?
      d = _desc.first.content
    end
    ap d
    d
  end

  def slug string
    string.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  end

end