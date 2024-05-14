require 'rails_helper'

RSpec.describe 'Post' do
  describe 'GET /api/posts' do
    it 'lists posts' do
      post = Post.create!(title: 'Foo', tags: [Tag.new(name: 'bar')])

      get api_posts_path(format: 'json')
      expect(response).to be_successful

      json = JSON.parse(response.body)
      expect(json).to be_a(Array)
      expect(json[0]['title']).to eq(post.title)
      expect(json[0]['tags'].count).to eq(post.tags.count)
      expect(json[0]['tags'].first['name']).to eq(post.tags.first.name)
    end
  end

  describe 'GET /api/posts/search/gatto' do
    it 'finds posts by title or tag' do
      _posts = [
        Post.create!(title: 'Gatto', tags: [Tag.new(name: 'gatto'), Tag.new(name: 'animale')]),
        Post.create!(title: 'Banana', tags: [Tag.new(name: 'banana'), Tag.new(name: 'frutto')]),
        Post.create!(title: 'Tigre', tags: [Tag.new(name: 'tigre'), Tag.new(name: 'gatto'), Tag.new(name: 'animale')])
      ]
      term = 'gatto'

      get api_posts_search_path(term:)
      expect(response).to be_successful
      puts response.body # FIXME: remove
      json = JSON.parse(response.body)
      expect(json).to be_a(Array)
      expect(json.length).to be(2)
      expect(json[0]['title']).to match(/#{term}/i)
      # expect(json[0]['tags'].count).to eq(post.tags.count)
      # expect(json[0]['tags'].first['name']).to eq(post.tags.first.name)
    end
  end
end
