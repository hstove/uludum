module ShareHelper
  
  def current_url
    host = if request.host == "127.0.0.1" then "localhost" else request.host end
    "#{request.protocol}#{host}:#{request.port}#{request.fullpath}"
  end

  def share_urls
    {
      facebook: "http://facebook.com/sharer/sharer.php",
      twitter: "http://twitter.com/share",
      google: "https://plus.google.com/share",
    }
  end

  def social_url_parameters
    {
      facebook: :u,
      twitter: :url,
      google: :url,
    }
  end

  def social_url provider, url=nil
    key = social_url_parameters[provider]
    (opts = {})[key] = url || root_url
    make_url share_urls[provider], opts
  end

  private

  def make_url url, opts={}
    url += "?"
    params = []
    opts.each do |k,v|
      params.push "#{k}=#{u(v)}"
    end
    url += params.join("&")
  end

end