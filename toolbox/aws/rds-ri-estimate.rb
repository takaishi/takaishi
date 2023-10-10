#!/usr/bin/env ruby

require 'bundler/inline'
require 'optparse'

gemfile true do
  source 'https://rubygems.org'
  gem "aws-sdk-rds"
  gem "terminal-table"
end

op = OptionParser.new
opts = {
  db_instance_class: '',
  product_description: ''
}

op.on('', '--db-instance-class VALUE', '') do |v|
  opts[:db_instance_class] = v
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
db_instance_class = opts[:db_instance_class]
product_description = opts[:product_description]

table = Terminal::Table.new do |t|
  t.headings = ['Duration (Year)', 'Offering Type', 'One Time Payment (USD)', 'Usage Charges (USD, Monthly)']
end

client = Aws::RDS::Client.new

DURATIONS.each do |duration|
  OFFERING_TYPES.each do |offering_type|
    resp = client.describe_reserved_db_instances_offerings({
                                                             db_instance_class: db_instance_class,
                                                             duration: duration,
                                                             product_description: product_description,
                                                             offering_type: offering_type,
                                                             multi_az: false,
                                                           })
    offering = resp.reserved_db_instances_offerings.find { |offering| offering.product_description == product_description }
    recurring_charge = offering.recurring_charges[0] if offering
    if offering
      table.add_row([duration, offering_type, offering.fixed_price, (recurring_charge.recurring_charge_amount * 24 * 30).floor(1)])
    else
      table.add_row([duration, offering_type, 'None', 'None'])
    end
  end
end

puts table