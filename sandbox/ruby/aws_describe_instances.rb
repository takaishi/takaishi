#!/usr/bin/env ruby
require 'aws-sdk-ec2'
require 'nokogiri'

def list_all_instances(client)
  instances = []
  # https://docs.aws.amazon.com/sdk-for-ruby/v2/api/Aws/EC2/Client.html#describe_instances-instance_method
  resp = client.describe_instances
  next_token = resp.next_token
  instances.concat(resp.reservations.map(&:instances).flatten)

  while next_token
    resp = client.describe_instances(next_token: next_token)
    next_token = resp.next_token
    instances.concat(resp.reservations.map(&:instances).flatten)
  end

  return instances
end

client = Aws::EC2::Client.new

instances = list_all_instances(client)

instances.each do |instance|
  p instance
end
