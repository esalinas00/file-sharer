require_relative './spec_helper'

describe 'Testing Account resource routes' do
  before do
    Account.dataset.delete
    SimpleFile.dataset.delete
    Folder.dataset.delete
  end

  describe 'Creating new account' do
    it 'HAPPY: should create a new unique account' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { username: 'test.name',
                   password: 'mypass',
                   email: 'test@email.com' }.to_json
      post '/api/v1/accounts/', req_body, req_header
      _(last_response.status).must_equal 201
      _(last_response.location).must_match(%r{http://})
    end

    it 'SAD: should not create users with duplicate names' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { username: 'test.name',
                   password: 'mypass',
                   email: 'test@email.com' }.to_json
      post '/api/v1/accounts/', req_body, req_header
      post '/api/v1/accounts/', req_body, req_header
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
    # it 'HAPPY: should find an existing account' do
    #   new_account = CreateNewAccount.call(
    #     username: 'test.name',
    #     email: 'test@email.com', password: 'mypassword')
    #
    #   new_floders = (1..3).map do |i|
    #     new_account.add_owned_folder(name: "Folder #{i}")
    #   end
    #
    #   get "/api/v1/accounts/#{new_account.username}"
    #   _(last_response.status).must_equal 200
    #
    #   results = JSON.parse(last_response.body)
    #   _(results['data']['attributes']['username']).must_equal new_account.username
    #   3.times do |i|
    #     _(results['relationships'][i]['id']).must_equal new_floders[i].id
    #   end
    # end

    it 'SAD: should not find non-existent account' do
      get "/api/v1/account/#{random_str(10)}"
      _(last_response.status).must_equal 404
    end
  end

  describe 'Creating new folder for account owner' do
    before do
      @account = CreateNewAccount.call(
        username: 'soumya.ray',
        email: 'sray@nthu.edu.tw',
        password: 'mypassword')
    end

    it 'HAPPY: should create a new unique folder for account' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { name: 'Demo Floder' }.to_json
      post "/api/v1/accounts/#{@account.username}/folders/",
           req_body, req_header
      _(last_response.status).must_equal 201
      _(last_response.location).must_match(%r{http://})
    end

    # it 'SAD: should not create folders with duplicate names' do
    #   req_header = { 'CONTENT_TYPE' => 'application/json' }
    #   req_body = { name: 'Demo Folder' }.to_json
    #   2.times do
    #     post "/api/v1/accounts/#{@account.username}/folders/",
    #          req_body, req_header
    #   end
    #   _(last_response.status).must_equal 400
    #   _(last_response.location).must_be_nil
    # end

    # it 'HAPPY: should encrypt relevant data' do
    #   original_url = 'http://example.org/project/proj.git'
    #
    #   fold = @account.add_owned_folder(name: 'Secret Project')
    #   fold.repo_url = original_url
    #   fold.save
    #
    #   original_desc = 'Secret file with database key'
    #   original_doc = 'key: 123456789'
    #   conf = fold.add_simple_file(filename: 'test_file.txt')
    #   conf.description = original_desc
    #   conf.document = original_doc
    #   conf.save
    #
    #   _(Folder[fold.id].repo_url).must_equal original_url
    #   _(Folder[fold.id].repo_url_encrypted).wont_equal original_url
    #
    #   _(SimpleFile[conf.id].description).must_equal original_desc
    #   _(SimpleFile[conf.id].description_encrypted).wont_equal original_desc
    #
    #   _(SimpleFile[conf.id].document).must_equal original_doc
    #   _(SimpleFile[conf.id].document_encrypted).wont_equal original_doc
    # end
  end



  describe 'Get index of all projects for an account' do
      # it 'HAPPY: should find all projects for an account' do
      #   my_account = CreateNewAccount.call(
      #     username: 'soumya.ray',
      #     email: 'sray@nthu.edu.tw',
      #     password: 'mypassword')
      #
      #   other_account = CreateNewAccount.call(
      #     username: 'lee123',
      #     email: 'lee@nthu.edu.tw',
      #     password: 'leepassword')
      #
      #   my_folders = []
      #   3.times do |i|
      #     my_folders << my_account.add_owned_folder(
      #       name: "Project #{my_account.id}-#{i}")
      #     other_account.add_owned_folder(
      #       name: "Project #{other_account.id}-#{i}")
      #   end
      #
      #   other_account.owned_projects.each.with_index do |proj, i|
      #     my_folders << my_account.add_project(proj) if i < 2
      #   end
      #
      #   result = get "/api/v1/accounts/#{my_account.username}/folders"
      #   _(result.status).must_equal 200
      #   folds = JSON.parse(result.body)
      #
      #   valid_ids = my_folders.map(&:id)
      #   _(folds['data'].count).must_equal 5
      #   folds['data'].each do |proj|
      #     _(valid_ids).must_include proj['id']
      #   end
      # end
    end
end
