module ShareHelper
  
  def current_url
    host = if request.host == "127.0.0.1" then "localhost" else request.host end
    "#{request.protocol}#{host}:#{request.port}#{request.fullpath}"
  end

  def twitter_url opts={}, root=false
    this_url = root ? root_url : current_url
    opts[:url] ||= this_url
    url = "http://twitter.com/share"
    make_url url, opts
  end

  def facebook_url opts={}, root=nil
    this_url = root ? root_url : current_url
    opts[:u] ||= this_url
    make_url "http://facebook.com/sharer/sharer.php", opts
  end

  def google_url opts={}, root=nil
    this_url = root ? root_url : current_url
    opts[:url] ||= this_url
    make_url "https://plus.google.com/share", opts
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