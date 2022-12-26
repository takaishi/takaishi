#!/usr/bin/env ruby

require 'bundler/inline'
require 'open3'

gemfile true do
  source 'https://rubygems.org'
  gem 'parallel', require: true
  gem 'octokit'
end

octokit = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])

p repo = octokit.repository('takaishi/takaishi')
