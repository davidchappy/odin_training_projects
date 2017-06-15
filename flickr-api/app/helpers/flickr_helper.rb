module FlickrHelper  
  def user_photos(user_id, photo_count = 12)
    flickr.photos.search(:user_id => user_id, :per_page => photo_count)
  end

  def photo_urls(source_photos)
    photos = []
    source_photos.each do |raw_photo|
      photos << "https://farm#{raw_photo['farm']}.staticflickr.com/#{raw_photo['server']}/#{raw_photo['id']}_#{raw_photo['secret']}.jpg"
    end
    photos
  end

  def render_flickr_sidebar_widget(user_id, photo_count = 12, columns = 2)
    begin
      photos = user_photos(user_id, photo_count).to_a.in_groups_of(2)
      render :partial => '/flickr/sidebar_widget', :locals => { :photos => photos }
    rescue Exception
      render :partial => '/flickr/unavailable'
    end
  end
end