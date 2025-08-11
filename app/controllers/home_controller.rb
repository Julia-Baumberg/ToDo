class HomeController < ApplicationController

  def index
    if current_user
      @tasks = current_user.tasks.due_soon(10)
    else
      @tasks = []
    end
  end

end
