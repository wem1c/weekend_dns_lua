-- Define module variable
local Decoding = {}

--- Decode domain name from binary DNS Question data
-- @param reader Reader object with response data loaded
-- @return decoded_name Decoded domain name
function Decoding.decode_name_simple(reader)
  -- Initialize variables
  local decoded_name = ""
  local parts = {}
  local part = ""
  local part_length = 0

  repeat
    -- Unpack the first byte to get the length of the part
    part_length = string.unpack(">I1", reader:read(1)) -- ">I1" = unsigned int 1 byte (big endian)

    -- Unpack the name part based on its length
    part = string.unpack(">c" .. part_length, reader:read(part_length)) -- ">cn" = fixed-sized string with n bytes

    -- Insert the part into the parts table
    table.insert(parts, part)

    -- Loop until we get to the end of the name denoted by a zero byte
  until part_length == 0

  -- Concatenate the parts with a dot separator to form the decoded name
  decoded_name = table.concat(parts, ".")

  -- Return the decoded name and the remaining data_bytes
  return decoded_name
end

--- Decode compressed domain name
-- @param pointer_byte_compressed - Compressed first byte of the pointer
-- @param reader - Reader object with response data loaded
-- @return decoded_name
local function decode_compressed_name(pointer_byte_compressed, reader)
  -- Decompress pointer byte
  local pointer_byte = pointer_byte_compressed & 63 -- 63 = 0011 1111

  -- Convert pointer byte to string (to be concatenated)
  pointer_byte = string.format("%c", pointer_byte) -- "%c" = char (ASCII)

  -- Get the pointer value by concatenating the decompressed
  -- first byte and the second byte
  local pointer_bytes = pointer_byte .. reader:read(1)

  -- Unpack the pointer value from the pointer bytes
  local pointer = string.unpack(">H", pointer_bytes)

  -- Save the current posiition of the reader
  local current_pos = reader:tell()

  -- Seek to the position the pointer points to
  reader:seek(pointer + 1, "set")

  -- Decode the name at current position
  local result = Decoding.decode_name(reader)

  -- Seek back to the saved position
  reader:seek(current_pos, "set")

  return result
end

--- Decode domain name
-- @param reader - Reader object with response data loaded
-- @return decoded_name
function Decoding.decode_name(reader)
  -- Initialize variables
  local decoded_name = ""
  local parts = {}
  local part = ""

  -- Initialize the part length to the value of the first byte
  local part_length = string.unpack(">I1", reader:read(1)) -- ">I1" = unsigned int 1 byte (big endian)

  -- Loop until we get to the end of the name denoted by a zero byte
  while part_length ~= 0 and part_length ~= nil do
    -- If the first to bits of the part length are 11, then it's compressed
    if (part_length & 192 ~= 0) then -- 192 = 1100 0000
      -- Decode the part based on the length
      part = decode_compressed_name(part_length, reader)

      -- Insert the part into the parts table
      table.insert(parts, part)

      -- Break the current loop iteration
      break
    else
      -- Unpack the part based on the length
      part = string.unpack(">c" .. part_length, reader:read(part_length)) -- ">cn" = fixed-sized string with n bytes

      -- Insert the part into the parts table
      table.insert(parts, part)
    end

    -- Update the part length to the value of the next byte
    part_length = string.unpack(">I1", reader:read(1)) -- ">I1" = unsigned int 1 byte (big endian)
  end

  -- Concatenate the parts with a dot separator to form the decoded name
  decoded_name = table.concat(parts, ".")

  return decoded_name
end

return Decoding
