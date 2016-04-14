require_relative './spec_helper'

describe 'Testing File resource routes' do
  before do
    User.dataset.delete
    SimpleFile.dataset.delete
  end

  describe 'Creating new file for user' do
    it 'HAPPY: should add a new file for an existing user' do
      existing_user = User.create(username: 'tester')

      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = {
        filename: 'Demo Configuration',
        description: 'test description',
        base64_document: 'test document',
        file_extension: 'test extension',
        remark: 'test remark',

       }.to_json
      post "/api/v1/users/#{existing_user.username}/files",
           req_body, req_header
      _(last_response.status).must_equal 201
      _(last_response.location).must_match(%r{http://})
    end

    it 'SAD: should not add a file for non-existant user' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = {
        filename: 'Demo Configuration',
        description: 'test description',
        base64_document: 'test document',
        file_extension: 'test extension',
        remark: 'test remark',

       }.to_json
      post "/api/v1/users/#{invalid_id(User)}/files",
           req_body, req_header
      _(last_response.status).must_equal 400
      _(last_response.location).must_be_nil
    end

    it 'SAD: should catch duplicate files within a user' do
      existing_user = User.create(username: 'tester')

      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = {
        filename: 'Demo Configuration',
        description: 'test description',
        base64_document: 'test document',
        file_extension: 'test extension',
        remark: 'test remark',

       }.to_json
      url = "/api/v1/users/#{existing_user.username}/files"
      post url, req_body, req_header
      post url, req_body, req_header
      _(last_response.status).must_equal 400
      _(last_response.location).must_be_nil
    end
  end

  describe 'Getting files' do
    it 'HAPPY: should find existing file' do
      f = {
        filename: 'Demo Configuration',
        description: 'test description',
        base64_document: 'test document',
        file_extension: 'test extension',
        remark: 'test remark',

       }
      file = User.create(username: 'tester', email: 'test@gmail.com')
                 .add_simple_file(f)

      get "/api/v1/users/tester/files/#{file.id}.json"
      _(last_response.status).must_equal 200
      parsed_config = JSON.parse(last_response.body)['data']['file']
      _(parsed_config['type']).must_equal 'file'
    end

    it 'SAD: should not find non-existant file and user' do
      username = invalid_id(User)
      file_id = invalid_id(SimpleFile)
      get "/api/v1/users/#{username}/files/#{file_id}"
      _(last_response.status).must_equal 404
    end

    it 'SAD: should not find non-existant file for existing user' do
      username = User.create(username: 'tester', email:'test@gmail.com').id
      file_id = invalid_id(SimpleFile)
      get "/api/v1/users/#{username}/files/#{file_id}"
      _(last_response.status).must_equal 404
    end
  end
end
