-- Import 3rd-party modules
local Struct = require "struct"

-- Import custom modules
local DNS = require "src.dns"
local Decoding = require "src.decoding"

-- Define module variable
local Parsing = {}

--- Parse DNS header binary data
-- @param header_bytes Binary data of DNS header
-- @return DNS.Header
function Parsing.parse_header(header_bytes)
  return DNS.Header(Struct.unpack(">HHHHHH", header_bytes))
end

--- Parse DNS question binary data
-- @param question_bytes Binary data of DNS question
-- @return DNS.Question
-- @return remaining_bytes Remaining bytes after parsing question
function Parsing.parse_question(question_bytes)
  local decoded_name, question_bytes_remaining = Decoding.decode_name_simple(question_bytes)
  local type, class = Struct.unpack(">HH", question_bytes_remaining:sub(1, 4))
  local bytes_remaining = question_bytes_remaining:sub(5)

  return DNS.Question(decoded_name, type, class), bytes_remaining
end

--- Parse DNS record binary data
-- @param record_bytes Binary data of DNS record
-- @return DNS.Record
function Parsing.parse_record(record_bytes)
  local name, record_bytes_remaining = Decoding.decode_name_simple(record_bytes)
  local type, class, ttl, data_len = Struct.unpack(">HHIH", record_bytes_remaining:sub(1, 10))
  local data = record_bytes_remaining:sub(11 + data_len)
  return DNS.Record(name, type, class, ttl, data)
end

return Parsing
