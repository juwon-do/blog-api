require 'rails_helper'

RSpec.describe "Posts", type: :request do
  describe "GET /posts" do
    it "works! (now write some real specs)" do
      get '/posts'
      expect(response).to have_http_status(200)
    end

    it "should return all posts in the db" do
      user = User.create!(
        email: "test@test.com",
        password: "password"
      )
      
      Post.create!(
        title: "Hello",
        body: "This is a new post",
        image: "google.com",
        user_id: user.id

      )
      get "/posts.json"
      posts = JSON.parse(response.body)      
      expect(response).to have_http_status(200)
      expect(posts.length).to eq(1)
    end
  end

  describe "GET /posts/:id" do
    it "should return a post in the db" do
      user = User.create!(
        email: "test@test.com",
        password: "password"
      )
      
      post = Post.create!(
        title: "Hello",
        body: "This is a new post",
        image: "google.com",
        user_id: user.id

      )

      get "/posts/#{post.id}.json"
      post = JSON.parse(response.body)
      expect(post['title']).to eq("Hello")
      expect(post['body']).to eq("This is a new post")
      expect(post['image']).to eq("google.com")
    end
  end
end
