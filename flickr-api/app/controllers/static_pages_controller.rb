class StaticPagesController < ApplicationController
  include FlickrHelper

  def home
    if params[:flickr_id]
      id = params[:flickr_id]
      photos = user_photos(id)
      @photos = photo_urls(photos)
    end
  end
end
