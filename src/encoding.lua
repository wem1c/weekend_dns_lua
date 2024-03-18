local Struct = require "struct"

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
  local encoded = ""

  -- Iterate over each part of the domain name,
  -- splitting on the '.' character
  for part in string.gmatch(name, "[^.]+") do
    encoded = encoded .. #part .. part
  end

  return Struct.pack(">s", encoded)
end

return Encoding
