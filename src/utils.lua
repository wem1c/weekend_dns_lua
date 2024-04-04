local Utils = {}

--- Print string byte per byte, as hexadecimal values
-- @param str The string to print
function Utils.print_bytes(str)
  for i = 1, #str do
    io.write(string.format("%02X ", str:byte(i)))
  end
  print("\n")
end

--- Pretty print an ip address string
-- @param ip_bytes - The byte string of the ip address to be printed
function Utils.print_ip(ip_bytes)
  local ip_parts = {}

  for i = 1, #ip_bytes do
    table.insert(ip_parts, string.format("%d", ip_bytes:byte(i)))
  end

  local ip = table.concat(ip_parts, ".")
  print("\tip ", ip)
end

function Utils.print_packet(packet)
  print("Decoded packet:\n")
  for k, v in pairs(packet) do
    print(k, v)
  end
  print("")

  print("Packet.header: \n")
  for k, v in pairs(packet.header) do
    print(k, v)
  end
  print("")

  print("Packet.questions: \n")
  for i = 1, #packet.questions do
    for k, v in pairs(packet.questions[i]) do
      print(k, v)
    end
    print("")
  end
  print("")

  print("Packet.answers: \n")
  for i = 1, #packet.answers do
    for k, v in pairs(packet.answers[i]) do
      if k == "data" then
        print("data")
        Utils.print_ip(v)
      else
        print(k, v)
      end
    end
    print("")
  end
  print("")

  print("Packet.authorities: \n")
  for i = 1, #packet.authorities do
    print(packet.authorities[i])
  end
  print("")

  print("Packet.additionals: \n")
  for i = 1, #packet.additionals do
    print(packet.additionals[i])
  end
  print("")
end

return Utils
