local Utils = {}

--- Print string byte per byte, as hexadecimal values
-- @param str The string to print
function Utils.print_bytes(str)
  for i = 1, #str do
    io.write(string.format("%02X ", str:byte(i)))
  end
  print("\n")
end

return Utils
