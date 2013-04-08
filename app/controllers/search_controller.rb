class SearchController < ApplicationController
  before_filter :get_query

  def khan
  end

  def youtube
    results = YoutubeSearch.search(@q, per_page: 10, page: params[:per_page])
    ap results
    vids = []
    results.each do |vid|
      vids << {
        title: vid['title'],
        id: vid['video_id']
      }
    end
    render json: { videos: vids }
  end

  def educreations
  end

  private

  def get_query
    @q = params[:q]
    error "you must specify a `q` parameter" if @q.nil? || @q.empty?
  end

  def error message
    json = {
      error: message
    }
    render json: json
  end
end
