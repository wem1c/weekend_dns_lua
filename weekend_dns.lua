--[[

  This is a toy implementation of a DNS resolver in Lua.

  It is a weekend project rewrite from Python by Conor
  C. Peterson (wem1c), based on a Wizard Zines tutorial
  written by Julia Evans. <3

  See: https://implement-dns.wizardzines.com/

  ]]


-- ======================================================
-- PART 1: Build a DNS query
-- ======================================================

-- Import custom modules
local QB = require "src.query_builder"
local Resolving = require "src.resolving"
local Utils = require "src.utils"

-- Define type and class constants
TYPE_A = 1
CLASS_IN = 1

-- Define domain name and record type variables
local domain_name = "www.example.com"
local record_type = TYPE_A

print("Building query for domain name: " .. domain_name .. " and record type: " .. record_type .. " ...\n")

-- Build the query
local query = QB.build_query(domain_name, record_type)

print("Query (bytes):\n")
Utils.print_bytes(query)

-- Send the query to Google's DNS server
local response = Resolving.send(query, "8.8.8.8", 53)

-- Exit early if the response is empty
if not response then
  print("No response.")
  return -1
end

-- Print the response
print("Response (bytes):\n")
Utils.print_bytes(response)

-- ======================================================
-- PART 2: Parse the response
-- ======================================================

-- Import modules
local Reader = require "src.modules.reader"
local Parsing = require "src.parsing"

-- Load the response into a reader object
local reader = Reader.new(response)

-- Decode the header and the question
local decoded_header = Parsing.parse_header(reader)
local decoded_question = Parsing.parse_question(reader)

print("Decoded header:\n")
for k, v in pairs(decoded_header) do
  print(k, v)
end

print("")

print("Decoded question:\n")
for k, v in pairs(decoded_question) do
  print(k, v)
end

print("")

local decoded_record = Parsing.parse_record(reader)

print("Decoded record:\n")
for k, v in pairs(decoded_record) do
  print(k, v)
end
