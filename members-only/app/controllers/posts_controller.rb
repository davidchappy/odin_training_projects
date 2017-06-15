class PostsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create] 

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(   title: params[:post][:title],
                        content: params[:post][:content],
                        user_id: current_user.id)
    if @post.save
      flash[:success] = "Nice post!"
      redirect_to posts_path
    else
      flash.now[:danger] = "Oops, please try to write the post again."
    end
  end

  def index
    @posts = Post.all
  end

  private

    def logged_in_user
      unless logged_in?
        flash[:danger] = "You need to be signed in."
        redirect_to login_url
      end
    end

end
