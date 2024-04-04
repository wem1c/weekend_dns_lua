-- Define the module table
local Reader = {}

--- Construct a new reader object
-- @param data - Byte data to be read
-- @return self - Reader object
function Reader.new(data)
  -- Keep track of the current position, and the data
  local self = {
    data = data,
    position = 1
  }

  -- Set the metatable for the object
  setmetatable(self, { __index = Reader })

  return self
end

--- Read an arbitrary amount of bytes
-- @param length - Length of byte data to be read
-- @return data - Byte data read
function Reader:read(length)
  -- Read the specified amount of bytes starting from the current position
  local data = self.data:sub(self.position, self.position + length - 1)

  -- Update the current position
  self.position = self.position + length

  return data
end

--- Seek to a specific position in the data
-- @param offset - Offset to seek to
-- @param [whence] - Where to seek from (one of 'set'(start), 'cur', 'end')
function Reader:seek(offset, whence)
  -- Set whence to 'cur' if not specified
  whence = whence or 'cur'

  -- Update the current position based on the whence value
  if whence == 'set' then
    self.position = offset
  elseif whence == 'cur' then
    self.position = self.position + offset
  elseif whence == 'end' then
    self.position = #self.data - offset + 1
  end
end

--- Obtain the current position in the data
-- @return The current position in the data
function Reader:tell()
  return self.position
end

--- Reset the reader to the beginning of the data
function Reader:reset()
  -- Set the current position to 1
  self.position = 1
end

-- Return the module table
return Reader
