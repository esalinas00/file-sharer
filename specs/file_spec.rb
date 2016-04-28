require_relative './spec_helper'

describe 'Testing File resource routes' do
  before do
    Folder.dataset.destroy
    SimpleFile.dataset.destroy
  end

  describe 'Creating new configurations for projects' do
    it 'HAPPY: should add a new configuration for an existing project' do
      existing_folder = Folder.create(name: 'Demo folder')

      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { filename: 'Demo Configuration' }.to_json
      post "/api/v1/folders/#{existing_folder.id}/files",
           req_body, req_header
      _(last_response.status).must_equal 201
      _(last_response.location).must_match(%r{http://})
    end

    it 'HAPPY: should encrypt relevant data' do
      original_doc = "---\ntest: 'testing'\ndata: [1, 2, 3]"
      original_desc = 'test description text'

      config = SimpleFile.new(filename: 'Secret folder')
      config.document = original_doc
      config.description = original_desc
      config.save
      id = config.id

      _(SimpleFile[id].document).must_equal original_doc
      _(SimpleFile[id].document_encrypted).wont_equal original_doc
      _(SimpleFile[id].description).must_equal original_desc
      _(SimpleFile[id].description_encrypted).wont_equal original_desc
    end

    it 'SAD: should not add a configuration for non-existant project' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { filename: 'Demo Configuration' }.to_json
      post "/api/v1/folders/#{invalid_id(Folder)}/files",
           req_body, req_header
      _(last_response.status).must_equal 400
      _(last_response.location).must_be_nil
    end

    it 'SAD: should catch duplicate config files within a project' do
      existing_folder = Folder.create(name: 'Demo folder')

      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { filename: 'Demo Configuration' }.to_json
      url = "/api/v1/folders/#{existing_folder.id}/files"
      post url, req_body, req_header
      post url, req_body, req_header
      _(last_response.status).must_equal 400
      _(last_response.location).must_be_nil
    end
  end

  describe 'Getting files' do
    it 'HAPPY: should find existing file' do
      folder = Folder.create(name: 'Demo_Folder')
                     .add_simple_file(filename: 'demo_config.rb')
      get "/api/v1/folders/#{folder.folder_id}/files/#{folder.id}"
      _(last_response.status).must_equal 200
      parsed_file = JSON.parse(last_response.body)['data']['file']
      _(parsed_file['type']).must_equal 'file'
    end

    it 'SAD: should not find non-existant folder and file' do
      fold_id = invalid_id(Folder)
      file_id = invalid_id(SimpleFile)
      get "/api/v1/folders/#{fold_id}/files/#{file_id}"
      _(last_response.status).must_equal 404
    end

    it 'SAD: should not find non-existant file for existing folder' do
      fold_id = Folder.create(name: 'Demo folder').id
      file_id = invalid_id(SimpleFile)
      get "/api/v1/folders/#{fold_id}/files/#{file_id}"
      _(last_response.status).must_equal 404
    end
  end
end
