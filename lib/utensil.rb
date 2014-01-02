module Utensil

  def self.render html
    # go through each <utensil>, parse JSON, and render utensil
    doc = Nokogiri::HTML(html)
    utensils = doc.css('utensil')
    utensils.each do |doc|
      doc.content = render_utensil(JSON.parse(doc.text))
    end
    doc.content
  end

  def self.render_utensil opts
    opts = Hashie::Mash.new(opts)
    case opts.type
    when "Khan Academy Video"
      if opts.videoId
        height = 360
        width = 640
        <<-eos
        <div class="utensil-video">
          <iframe frameborder="0" scrolling="no" width="#{width}" height="#{height}"
          src="https://www.khanacademy.org/embed_video?v=#{opts.videoId}"
          allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe>
        </div>
        eos
      end
    when "Equation Helper"
      <<-eos
      <img src="https://chart.googleapis.com/chart?cht=tx&chl=#{URI::encode(opts.equation)}">
      eos
    when "Upload a Picture"
      <<-eos
      <br>
      <div class="utensil-picture" style="width: 400px;">
        <a href="#{opts.picture_url}">
          <img src="#{opts.picture_url}/convert?w=400" width="400"
          style="display: block; margin: 0px auto;">
        </a>
      </div>
      <br>
      eos
    end
  end
end