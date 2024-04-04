-- Import DNS classes
local DNS          = require "src.dns"

-- Import the encoding module
local Encoding     = require "src.encoding"

-- Define the QueryBuilder module
local QueryBuilder = {}

--- Build a DNS query
-- @param domain_name The domain name to query
-- @param record_type The record type to query
-- @return The binary data representing the DNS query
function QueryBuilder.build_query(domain_name, record_type)
  local encoded_name = Encoding.encode_domain_name(domain_name)

  -- TODO: remove magic number
  -- local id = math.random(0, 65535)
  local id = 0x8298

  -- "According to RFC 1035, the Recursion Desired bit is the 9th bit
  -- from the right in the flags field, and 1 << 8 gives you a number
  -- that has a 1 in the 9th bit position from the right and 0
  -- everywhere else (1 << 8 = 100000000 in binary)."
  --
  -- See https://implement-dns.wizardzines.com/book/part_1#build-the-query
  local RECURSION_DESIRED = 1 << 8

  -- Create the query header and question objects
  local header = DNS.Header(id, RECURSION_DESIRED, 1)
  local question = DNS.Question(encoded_name, record_type, CLASS_IN)

  -- Encode the header and question objects to binary data
  local header_bytes = Encoding.header_to_bytes(header)
  local question_bytes = Encoding.question_to_bytes(question)

  -- Combine the header and question bytes into a single binary data blob
  local query = header_bytes .. question_bytes

  return query
end

return QueryBuilder
