#!/usr/bin/env ruby

require 'bundler/inline'
require 'optparse'

gemfile true do
  source 'https://rubygems.org'
  gem "aws-sdk-elasticache"
  gem "terminal-table"
end

op = OptionParser.new
opts = {
  cache_node_type: '',
  product_description: ''
}

op.on('', '--cache-node-type VALUE', '') do |v|
  opts[:cache_node_type] = v
end

op.on('', '--product-description VALUE', '') do |v|
  opts[:product_description] = v
end

begin
  args = op.parse(ARGV)
rescue OptionParser::InvalidOption => e
  usage e.message
end

OFFERING_TYPES = ["No Upfront", "Partial Upfront", "All Upfront"]
DURATIONS = ["1", "3"]
cache_node_type = opts[:cache_node_type]
product_description = opts[:product_description]

table = Terminal::Table.new do |t|
  t.headings = ['Duration (Year)', 'Offering Type', 'One Time Payment (USD)', 'Usage Charges (USD, Monthly)']
end

client = Aws::ElastiCache::Client.new

DURATIONS.each do |duration|
  OFFERING_TYPES.each do |offering_type|
    resp = client.describe_reserved_cache_nodes_offerings({
                                                            cache_node_type: cache_node_type,
                                                             duration: duration,
                                                             product_description: product_description,
                                                             offering_type: offering_type,
                                                           })
    offering = resp.reserved_cache_nodes_offerings.find { |offering| offering.product_description == product_description }
    recurring_charge = offering.recurring_charges[0] if offering
    table.add_row([duration, offering_type, offering.fixed_price, (recurring_charge.recurring_charge_amount * 24 * 30).floor(1)]) if offering
  end
end

puts table