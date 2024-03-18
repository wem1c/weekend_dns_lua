-- Import 3rd-party modules
local Struct = require("struct")

-- Define module variable
local Decoding = {}

--- Decode domain name from binary DNS Question data
-- @param question_bytes Binary data of DNS question
-- @return decoded_name Decoded domain name
-- @return remaining_bytes Remaining bytes after decoding name
function Decoding.decode_name_simple(data_bytes)
  local decoded_name = ""
  local bytes_remaining = data_bytes

  repeat
    local length = bytes_remaining:byte(1)
    decoded_name = decoded_name .. bytes_remaining:sub(1, 1 + length) .. "."
    bytes_remaining = bytes_remaining:sub(2 + length + 1)
  until length == 0

  return decoded_name, bytes_remaining
end

local function decode_compressed_name(length, data_bytes)
  local pointer_bytes = data_bytes:sub(1, 1 + length)
  local pointer = Struct.unpack(">H", pointer_bytes)
  print(pointer)
  return "test"
end

function Decoding.decode_name(data_bytes)
  local decoded_name = ""
  local bytes_remaining = data_bytes

  repeat
    local length = bytes_remaining:byte(1)
    if length & 11000000 == 0 then
      decoded_name = decoded_name .. decode_compressed_name(length, bytes_remaining)
    else
      decoded_name = decoded_name .. bytes_remaining:sub(1, 1 + length) .. "."
      bytes_remaining = bytes_remaining:sub(2 + length + 1)
    end
  until length == 0

  return decoded_name, bytes_remaining
end

-- def decode_compressed_name(length, reader):
--     pointer_bytes = bytes([length & 0b0011_1111]) + reader.read(1)
--     pointer = struct.unpack("!H", pointer_bytes)[0]
--     current_pos = reader.tell()
--     reader.seek(pointer)
--     result = decode_name(reader)
--     reader.seek(current_pos)
--     return result

return Decoding
