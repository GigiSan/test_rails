class Api::PostsController < ApplicationController
  def index
    @posts = Post.all

    render json: serialize_posts(@posts)
  end

  def search
    term = params[:term]
    return index if term.blank?

    # TODO: sanitize_sql_like not working?
    # TODO: distinct necessary?
    @posts = Post.joins(:tags).where('title ILIKE ?', "%#{term}%").or(
      Post.where(tags: { name: term })
    ).distinct
    # Article.joins(:categories).where(categories: { id: 2 } )
    render json: serialize_posts(@posts)
  end

  def serialize_posts(posts)
    posts.map do |post|
      {
        title: post.title,
        id: post.id,
        tags: post.tags.map { |tag| { name: tag.name } }
      }
    end
  end
end

