require_relative './spec_helper'

describe 'Testing Folder resource routes' do
  before do
    SimpleFile.dataset.destroy
    Folder.dataset.destroy
    Account.dataset.destroy
  end

  describe 'Finding existing folders' do
    it 'HAPPY: should find an existing folder' do
      new_folder = Folder.create(name: 'demo_folder')

      new_files = (1..3).map do |i|
        new_folder.add_simple_file(filename: "file#{i}.rb")
      end

      get "/api/v1/folders/#{new_folder.id}"
      _(last_response.status).must_equal 200

      results = JSON.parse(last_response.body)
      _(results['data']['id']).must_equal new_folder.id

      3.times do |i|
        _(results['relationships'][i]['id']).must_equal new_files[i].id
      end

    end

    it 'SAD: should not find non-existent folders' do
      get "/api/v1/folders/#{invalid_id(Folder)}"
      _(last_response.status).must_equal 404
    end
  end
end
