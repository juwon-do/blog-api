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

  describe 'POST /posts' do
    it "should create a new post" do
      user = User.create!(
        email: "test@test.com",
        password: "password"
      )

      post "/sessions", params: {
        email: "test@test.com",
        password: "password"
      }
      jwt =  JSON.parse(response.body)['jwt']

      post "/posts.json", params: {
        title: "Hello RSPEC",
        body: "Try to use rspec for tesing",
        image: "google.com"
      }, headers: {
        "Authorization" => "Bearer #{jwt}"
      }
      post = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(post['title']).to eq("Hello RSPEC")
    end
  end

  describe 'PATCH /posts/:id' do
    it "should update a post" do
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
      post "/sessions", params: {
        email: "test@test.com",
        password: "password"
      }
      jwt =  JSON.parse(response.body)['jwt']

      patch "/posts/#{post.id}", params: {
        title: "HELLO GOOGLE",
        body: "GOOGLE SEARCH will be replaced by chatgpt",
        image: "google.com"
      }, headers: {
        "Authorization" => "Bearer #{jwt}"
      }
      update = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(update['title']).to eq("HELLO GOOGLE")
    end
  end

  describe 'DELETE /posts/:id' do
    it "should delete a post" do
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
      post "/sessions", params: {
        email: "test@test.com",
        password: "password"
      }
      jwt =  JSON.parse(response.body)['jwt']
      
      delete "/posts/#{post.id}" , headers: {
        "Authorization" => "Bearer #{jwt}"
      }
      delete = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(delete['message']).to eq("Post successfully destroyed!")
    end
  end
end

