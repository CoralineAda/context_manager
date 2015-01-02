class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  http_basic_authenticate_with name: ENV['USER_NAME'], password: ENV['PASSWORD']

end
