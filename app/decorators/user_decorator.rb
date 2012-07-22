class UserDecorator < ApplicationDecorator
  decorates :user

  def asciicasts_count
    model.asciicasts.count
  end
end
