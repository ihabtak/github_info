class AppController < ApplicationController
  def index
  end

  def show
    user_id = Github::User.get_user_id(params[:username])
    @user = Github::User.find(params[:username], user_id)
    # require 'irb'
    # ARGV.clear
    # IRB.start
    puts @user.to_s
  end

  skip_before_action :verify_authenticity_token
end
