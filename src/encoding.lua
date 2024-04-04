-- Import modules
local Struct   = require "src/modules/struct" -- TODO: deprecate Struct for string

-- Define module variable
local Encoding = {}

--- Convert a DNS header to binary data
-- @param header The DNS header to convert
-- @return The binary data representing the DNS header
function Encoding.header_to_bytes(header)
  local header_fields = { header.id, header.flags, header.num_questions, header.num_answers, header.num_authorities,
    header.num_additionals }

  return Struct.pack(">HHHHHH", table.unpack(header_fields))
end

--- Convert a DNS question to binary data
-- @param question The DNS question to convert
-- @return The binary data representing the DNS question
function Encoding.question_to_bytes(question)
  return question.name .. Struct.pack(">HH", question.type, question.class)
end

--- Encode domain name
-- @param name The domain name to encode
-- @return The encoded domain name
function Encoding.encode_domain_name(name)
  -- Initialize an empty table to store the parts of the domain name
  local parts = {}
  local parts_count = 0

  -- Split the domain string on the dot (".") character
  for part in string.gmatch(name, "[^.]+") do
    -- Increment part counter
    parts_count = parts_count + 1

    -- Insert the length of the part followed by the part itself into the table
    table.insert(parts, tostring(#part))
    table.insert(parts, part)
  end
  -- Add a zero byte at the end of the last part to indicate the end of the domain name
  table.insert(parts, "0")

  local format = ">"
  for i = 1, parts_count do
    format = format .. "bc0"
  end
  format = format .. "b"

  -- Return the encoded domain name as a binary string
  return Struct.pack(format, table.unpack(parts))
end

return Encoding
