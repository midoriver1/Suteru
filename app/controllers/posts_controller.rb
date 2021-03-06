class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :destroy, :show]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  PER = 8

  def index
    @posts = Post.all.order(created_at: :desc).page(params[:page]).per(PER)
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to posts_path, notice: "投稿しました"
    else
      render 'new'
    end
  end

  def show
    @favorite = current_user.favorites.find_by(post_id: @post.id)
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to posts_path, notice: "投稿を編集しました"
    else
      render 'edit'
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice:"投稿を削除しました"
  end

  private

  def post_params
    params.require(:post).permit(:title,:comment,:image, :image_cache)
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def ensure_correct_user
    @post = Post.find_by(id:params[:id])
    if @post.user_id != current_user.id
      flash[:notice] = "アクセス権限がありません"
      redirect_to posts_path
    end
  end

end
