class AsciicastDecorator < ApplicationDecorator
  decorates :asciicast

  THUMBNAIL_WIDTH = 20
  THUMBNAIL_HEIGHT = 10
  MAX_DELAY = 5.0

  class EscapedStdoutString
    def initialize(string)
      @string = string
    end

    def as_json(*args)
      self
    end

    def encode_json(*args)
      @string.bytes.map { |c| c.chr(Encoding::UTF_8) }.join.to_json
    end
  end

  def user
    @user ||= UserDecorator.new(asciicast.user)
  end

  def as_json(*args)
    data = model.as_json(*args)
    data['stdout'] = stdout
    data['stdout_timing'], saved_time = stdout_timing
    data['duration'] = data['duration'] - saved_time

    data
  end

  def stdout
    EscapedStdoutString.new(asciicast.stdout.try(:read).to_s)
  end

  def stdout_timing
    saved_time = 0

    if file = asciicast.stdout_timing.file
      data = file.read.lines.map do |line|
        delay, n = line.strip.split
        delay = delay.to_f

        if time_compression && delay > MAX_DELAY
          saved_time += (delay - MAX_DELAY)
          delay = MAX_DELAY
        end

        [delay, n.to_i]
      end
    else
      data = nil
    end

    [data, saved_time]
  end

  def os
    return 'unknown' if uname.blank?

    if uname =~ /Linux/
      'Linux'
    elsif uname =~ /Darwin/
      'OSX'
    else
      uname.split(' ', 2)[0]
    end
  end

  def terminal_type
    asciicast.terminal_type || '?'
  end

  def shell
    File.basename(asciicast.shell.to_s)
  end

  def title
    if asciicast.title.present?
      asciicast.title
    elsif command.present?
      "$ #{command}"
    else
      "##{id}"
    end
  end

  def thumbnail(width = THUMBNAIL_WIDTH, height = THUMBNAIL_HEIGHT)
    if @thumbnail.nil?
      lines = model.snapshot.to_s.split("\n")

      top_lines = lines[0...height]
      top_text = prepare_lines(top_lines, width, height).join("\n")

      bottom_lines = lines.reverse[0...height].reverse
      bottom_text = prepare_lines(bottom_lines, width, height).join("\n")

      if top_text.gsub(/\s+/, '').size > bottom_text.gsub(/\s+/, '').size
        @thumbnail = top_text
      else
        @thumbnail = bottom_text
      end
    end

    @thumbnail
  end

  def description
    text = asciicast.description.to_s
    markdown(text)
  end

  def author_profile_link(options = {})
    if asciicast.user
      if options[:avatar]
        img = avatar_img(asciicast.user) + " "
      else
        img = ""
      end

      text = img + "~#{asciicast.user.nickname}"
      path = h.profile_path(asciicast.user)

      h.link_to text, path
    else
      if asciicast.username.present?
        "~#{asciicast.username}"
      else
        "anonymous"
      end
    end
  end

  private

  def prepare_lines(lines, width, height)
    (height - lines.size).times { lines << '' }

    lines.map do |line|
      line = line[0...width]
      line << ' ' * (width - line.size)
      line
    end
  end
end
