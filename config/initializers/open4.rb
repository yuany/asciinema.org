if IO.respond_to?(:popen4)
  def open4(*args)
    IO.popen4(*args)
  end
else
  require 'open4'
end
