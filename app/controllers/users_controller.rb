class UsersController < ApplicationController
  def index
    logger.debug('hi')
    render json: {
      contents: 'hi'
    }.as_json
  end
end
