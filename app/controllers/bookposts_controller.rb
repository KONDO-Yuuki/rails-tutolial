class BookpostsController < ApplicationController
  before_action :logged_in_user, only: %i[create destroy]
  before_action :correct_user,   only: :destroy

  def create
    @bookpost = current_user.bookposts.build(bookpost_params)
    if @bookpost.save
      flash[:success] = 'Bookpost created!'
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @bookpost.destroy
    flash[:success] = 'Bookpost deleted'
    redirect_back(fallback_location: root_url)
  end

  private

  def bookpost_params
    params.require(:bookpost).permit(:content)
  end

  def correct_user
    @bookpost = current_user.bookposts.find_by(id: params[:id])
    redirect_to root_url if @bookpost.nil?
  end
end
