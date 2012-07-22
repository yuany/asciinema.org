class UserDecorator < ApplicationDecorator
  decorates :user

  def asciicasts_count
    model && model.asciicasts.count
  end

  def avatar_img(options = {})
    klass = options[:class] || "avatar"
    nickname =  user && "~#{user.nickname}"

    h.image_tag user && user.avatar_url || default_avatar_url,
      :title => nickname, :alt => nickname, :class => klass
  end

  def default_avatar_url
    h.image_path "default_avatar.png"
  end

  def avatar_profile_link
    if user
      h.link_to h.profile_path(user) do
        avatar_img :class => ''
      end
    else
      avatar_img :class => ''
    end
  end
end
