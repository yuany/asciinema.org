module ApplicationHelper
  def page_title
    title = "ascii.io"

    if @title
      title = "#{@title} - #{title}"
    end

    title
  end

  def twitter_auth_path
    "/auth/twitter"
  end

  def github_auth_path
    "/auth/github"
  end

  def default_avatar_url
    image_path "default_avatar.png"
  end

  def avatar_img(user, options = {})
    klass = options[:class] || "avatar"
    nickname =  "~#{user.nickname}"
    image_tag user.avatar_url || default_avatar_url,
      :title => nickname, :alt => nickname, :class => klass
  end

  def markdown(&block)
    text = capture(&block)
    MKD_RENDERER.render(capture(&block)).html_safe
  end

  def indented(string, width)
    string.lines.map { |l| "#{' ' * width}#{l}" }.join('')
  end
end
