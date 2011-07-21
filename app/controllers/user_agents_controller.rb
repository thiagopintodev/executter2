class UserAgentsController < ApplicationController
  # GET /user_agents
  def index
    @user_agents = UserAgent.all
  end
end
