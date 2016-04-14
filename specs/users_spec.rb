require_relative './spec_helper'

describe 'Testing Project resource routes' do
  before do
    User.dataset.delete
    SimpleFile.dataset.delete
  end

  describe 'Creating new users' do
    it 'HAPPY: should create a new unique user' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { username: 'JohnDoe', email: 'demo@gmail.com'}.to_json
      post '/api/v1/users/', req_body, req_header
      _(last_response.status).must_equal 201
      _(last_response.location).must_match(%r{http://})
    end

    it 'SAD: should not create users with duplicate names' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { username: 'JohnDoe' }.to_json
      post '/api/v1/users/', req_body, req_header
      post '/api/v1/users/', req_body, req_header
      _(last_response.status).must_equal 400
      _(last_response.location).must_be_nil
    end
  end

  describe 'Finding existing users' do
    it 'HAPPY: should find an existing user' do
      new_user = User.create(username: 'JohnDoe', email: "JohnDoe@gmail.com")

      new_files = (1..3).map do |i|
        f = {
          filename: "random_file#{i}.rb",
          description: "test string#{i}",
          base64_document: "+#{i}=",
          file_extension: "rb",
          remark: "good"
        }
        new_user.add_simple_file(f)
      end

      get "/api/v1/users/JohnDoe"
      _(last_response.status).must_equal 200

      results = JSON.parse(last_response.body)
      _(results['data']['attributes']['username']).must_equal new_user.username
      3.times do |i|
        _(results['relationships'][i]['id']).must_equal new_files[i].id
      end
    end

    it 'SAD: should not find non-existent users' do
      get "/api/v1/users/#{invalid_id(User)}"
      _(last_response.status).must_equal 404
    end
  end

  describe 'Getting an index of existing users' do
    it 'HAPPY: should find list of existing users' do
      (1..5).each { |i| User.create(username: "JaneDoe#{i}", email: "JaneDoe#{i}@gmail.com") }
      result = get '/api/v1/users'
      users = JSON.parse(result.body)
      _(users['data'].count).must_equal 5
    end
  end
end
