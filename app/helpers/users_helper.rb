module UsersHelper

  #Returns the Gravatar for the given user
  def gravatar_for(user, options = { size: 80 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar", size: size)
  end

  def current_user?(user)
    return false if current_user.nil? || current_user.id != user.id
    return true
  end
end
