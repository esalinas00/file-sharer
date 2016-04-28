require_relative './spec_helper'

describe 'Testing Project resource routes' do
  before do
    Account.dataset.delete
    SimpleFile.dataset.delete
    Folder.dataset.delete

  end

  describe 'Creating new account' do
    it 'HAPPY: should create a new unique account' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { username: 'JohnDoe', email: 'demo@gmail.com', password:'1234'}.to_json
      post '/api/v1/accounts/', req_body, req_header
      _(last_response.status).must_equal 201
      _(last_response.location).must_match(%r{http://})
    end

    it 'SAD: should not create users with duplicate names' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { username: 'JohnDoe', email: 'demo@gmail.com', password:'1234' }.to_json
      post '/api/v1/account/', req_body, req_header
      post '/api/v1/account/', req_body, req_header
      _(last_response.status).must_equal 400
      _(last_response.location).must_be_nil
    end
  end

  describe 'Testing unit level properties of accounts' do
    before do
      @original_password = 'mypassword'
      @account = CreateNewAccount.call(
        username: 'soumya.ray',
        email: 'sray@nthu.edu.tw',
        password: @original_password)
    end

    it 'HAPPY: should hash the password' do
      _(@account.password_hash).wont_equal @original_password
    end

    it 'HAPPY: should re-salt the password' do
      hashed = @account.password_hash
      @account.password = @original_password
      @account.save
      _(@account.password_hash).wont_equal hashed
    end
  end

  describe 'Finding existing account' do
    it 'HAPPY: should find an existing account' do
      new_user = Account.create(username: 'JohnDoe', email: "JohnDoe@gmail.com", password: "password")

      new_files = (1..3).map do |i|
        new_user.add_simple_file(f)
      end

      get "/api/v1/account/JohnDoe"
      _(last_response.status).must_equal 200

      results = JSON.parse(last_response.body)
      _(results['data']['attributes']['username']).must_equal new_user.username
      3.times do |i|
        _(results['relationships'][i]['id']).must_equal new_files[i].id
      end
    end

    it 'SAD: should not find non-existent account' do
      get "/api/v1/account/#{invalid_id(Account)}"
      _(last_response.status).must_equal 404
    end
  end

  # describe 'Getting an index of existing users' do
  #   it 'HAPPY: should find list of existing users' do
  #     (1..5).each { |i| Account.create(username: "JaneDoe#{i}", email: "JaneDoe#{i}@gmail.com") }
  #     result = get '/api/v1/account'
  #     users = JSON.parse(result.body)
  #     _(users['data'].count).must_equal 5
  #   end
  # end
end
