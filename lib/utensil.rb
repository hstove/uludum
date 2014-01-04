module Utensil

  def self.render html
    # go through each <utensil>, parse JSON, and render utensil
    doc = Nokogiri::HTML(html)
    utensils = doc.css('utensil')
    utensils.each do |doc|
      doc.inner_html = render_utensil(JSON.parse(doc.text))
    end
    html = doc.inner_html
    html.gsub!("<br><br>","</p><p>")
    html
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
    when "Upload a Video"
      <<-eos
      <div class="utensil-video">
        <video src="#{opts.video_url}" width="640"
        style="display: block; margin: 0px auto;" controls>
          This video type is not available with your current browser.
        </video>
      </div>
      eos
    when "Educreations Video"
      <<-eos
      <iframe width="640" height="360"
      src="http://www.educreations.com/lesson/embed/#{opts.video_id}"
      frameborder="0"
      webkitAllowFullScreen mozallowfullscreen allowfullscreen
      style="display: block; margin: 0px auto;"
      ></iframe>
      eos
    when "Youtube Video"
      <<-eos
      <div class="utensil-video">
        <iframe width="640" height="360"
        src="https://www.youtube.com/embed/#{opts.video_id}"
        frameborder="0"
        webkitAllowFullScreen mozallowfullscreen allowfullscreen
        style="display: block; margin: 0px auto;"
        ></iframe>
      </div>
      eos
    else
      ""
    end
  end
end