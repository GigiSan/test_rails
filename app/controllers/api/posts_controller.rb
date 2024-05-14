class Api::PostsController < ApplicationController
  def index
    @posts = Post.all

    render json: serialize_posts(@posts)
  end

  def search
    term = params[:term]
    return index if term.blank?

    @posts = Post.where('title ILIKE ?', "%#{term}%") # TODO: sanitize_sql_like?
    # @posts = Post.join(:tags).where(tags: {})
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

# Article.join(:categories).where(categories: { id: 2 } )
