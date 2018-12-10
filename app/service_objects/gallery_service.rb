class GalleryService < Showoff::Services::Base
  include Showoff::Concerns::ImageDecodable

  def import_from_url(url)
    object.send(attribute).create(image: URI.parse(url))
    object.save
  end

  def import_from_data(data)
    object.send(attribute).create(image: decode_base_64_image(data))
    object.save
  end

  def import_from_gravatar(email)
    gravatar_id = Digest::MD5.hexdigest(email)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}.png?d=mm&s=800"
    import_from_url(gravatar_url)
  end

  private
  def attribute
    @attribute = params[:attribute].to_s if @params[:attribute] && !@attribute
    @attribute ||= :gallery_images
  end

  def object
    @object ||= @params[:klass].constantize.find_by(id: @params[:id])
  end
end
