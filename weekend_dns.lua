-- Import custom modules
local QB = require "src.query_builder"
local Resolving = require "src.resolving"
local Utils = require "src.utils"
local Parsing = require "src.parsing"

-- Define constants
TYPE_A = 1
CLASS_IN = 1

local domain_name = "www.example.com"
local record_type = TYPE_A
print("Domain and record: ", domain_name, record_type, "\n")

local query = QB.build_query(domain_name, record_type)
print("Query (bytes):")
Utils.print_bytes(query)

local query_test = QB.build_query("www.example.com", record_type)
print("Query_test (bytes):")
Utils.print_bytes(query_test)

local query_solved =
"\xcb\x01\x00\x00\x01\x00\x00\x00\x00\x00\x00\x33\x77\x77\x77\x37\x65\x78\x61\x6D\x70\x6C\x65\x33\x63\x6F\x6D\x00\x00\x01\x00\x01"

local response = Resolving.send(query_solved, "8.8.8.8", 53)

-- Print the response
print("Response (bytes):")
Utils.print_bytes(response)

local decoded_header = Parsing.parse_header(response)
print("Header:")
for k, v in pairs(decoded_header) do
  print(k, v)
end

local decoded_question = Parsing.parse_question(response)
print("question:")
for k, v in pairs(decoded_question) do
  print(k, v)
end

local decoded_record = Parsing.parse_record(response)
print("record:")
for k, v in pairs(decoded_record) do
  print(k, v)
end
