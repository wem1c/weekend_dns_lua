local Utils = {}

--- Print string byte per byte, as hexadecimal values
-- @param str The string to print
function Utils.print_bytes(str)
  for i = 1, #str do
    io.write(string.format("%02X ", str:byte(i)))
  end
  print("\n")
end

--- Pretty print an ipv4 address string
-- @param ip_bytes - The byte string of the ip address to be printed
function Utils.print_ipv4(ip_bytes)
  local ip = string.format("%d.%d.%d.%d", ip_bytes:byte(1), ip_bytes:byte(2), ip_bytes:byte(3), ip_bytes:byte(4))
  print("\tip ", ip)
end

return Utils
