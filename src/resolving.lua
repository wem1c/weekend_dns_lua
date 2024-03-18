-- Import 3rd party module
local Socket = require("socket")

-- Define module variable
local Resolving = {}

function Resolving.send(query, ip, port)
  print("==========================================")
  print("Sending query to: ", string.format("%s:%i", ip, port))

  -- Create a UDP socket
  local sock = Socket.udp()
  print("Opened socket: ", sock)

  -- Set socket timeout
  sock:settimeout(5)

  -- Send our query to 8.8.8.8, port 53. Port 53 is the DNS port.
  if not sock:sendto(query, ip, port)
  then
    print("Error sending query")
    return
  end
  print("Query sent.")

  -- Read the response. UDP DNS responses are usually less than 512 bytes
  -- (see https://www.netmeister.org/blog/dns-size.html for MUCH more on that)
  -- so reading 1024 bytes is enough
  local response, _, _ = sock:receivefrom(1024)
  if response == nil then
    print("Error receiving response")
    return
  end
  print("Response received.")

  -- Close the socket when done
  sock:close()
  print("Socket closed.")
  print("==========================================\n")

  return response
end

return Resolving
