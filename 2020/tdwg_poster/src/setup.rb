require 'byebug'
require 'cgi'
require 'json'
require 'net/http'
require 'amazing_print'

LOCAL_URL = 'http://127.0.0.1:3000/api/v1'
INHS_TOKEN = 'OqtLJp17FvEDcdZvmdD6WA'

CURRENT_TOKEN = INHS_TOKEN
CURRENT_URL = LOCAL_URL 

# TW_PATH=/path/to/taxonworks && export TW_PATH

if !ENV['TW_USER_TOKEN']
  puts 'TW_USER_TOKEN=<> && export TW_USER_TOKEN'
  exit
end
TOKEN  = ENV['TW_USER_TOKEN']

# Find Tommy
#
def tommy
  first_name = 'Thomas'
  last_name = 'McElrath'

  find_tommy = CURRENT_URL + '/people?' + 'first_name=' + first_name + '&last_name=' + last_name  + '&token=' + TOKEN

  puts find_tommy 

  b = URI(find_tommy)
  n = JSON.parse(::Net::HTTP.get(b))
  ap n

  n.first
end
