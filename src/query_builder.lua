local DNS          = require "src.dns"
local Encoding     = require "src.encoding"
local utils        = require "src.utils"

local QueryBuilder = {}

--- Build a DNS query
-- @param domain_name The domain name to query
-- @param record_type The record type to query
-- @return The binary data representing the DNS query
function QueryBuilder.build_query(domain_name, record_type)
  print("Query Builder ==========================\n")

  local encoded_name = Encoding.encode_domain_name(domain_name)
  print("Encoded name: ", encoded_name)

  -- local id = math.random(0, 65535)
  local id = 0x8298 -- TODO: remove this magic number

  -- "According to RFC 1035, the Recursion Desired bit is the 9th bit
  -- from the right in the flags field, and 1 << 8 gives you a number
  -- that has a 1 in the 9th bit position from the right and 0
  -- everywhere else (1 << 8 = 100000000 in binary)."
  --
  -- See https://implement-dns.wizardzines.com/book/part_1#build-the-query
  local RECURSION_DESIRED = 1 << 8

  local header = DNS.Header(id, 1, RECURSION_DESIRED)
  local question = DNS.Question(encoded_name, record_type, CLASS_IN)

  local header_bytes = Encoding.header_to_bytes(header)
  print(type(header_bytes))
  utils.print_bytes(header_bytes)
  local question_bytes = Encoding.question_to_bytes(question)
  utils.print_bytes(question_bytes)

  print("========================================\n")

  return header_bytes .. question_bytes
end

return QueryBuilder
