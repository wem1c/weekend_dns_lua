-- Import local modules
local QB = require "src.query_builder"
local Utils = require "src.utils"
local Parsing = require "src.parsing"

-- Import 3rd party modules
local Socket = require("socket")

-- Define module variable
local Resolving = {}

--- Send DNS query for a given domain name to a given IP address and parse the response
-- @param ip_address The IP address to send the query to
-- @param domain_name The domain name to query
-- @param record_type The record type to query for (A, AAAA, MX, etc.)
-- @return Parsed DNS Packet object
local function send_query(ip_address, domain_name, record_type)
  print("Building query for domain name: " .. domain_name .. " and record type: " .. TYPE_A)
  print()
  local query = QB.build_query(domain_name, record_type)

  print("Query (bytes):\n")
  Utils.print_bytes(query)

  print()
  print("==========================================")
  print("Sending query to: ", string.format("%s:%i", ip_address, 53))

  -- Create a UDP socket
  local sock = Socket.udp()
  print("Opened socket: ", sock)

  -- Set socket timeout
  sock:settimeout(5)

  -- Send our query to 8.8.8.8, port 53. Port 53 is the DNS port.
  if not sock:sendto(query, ip_address, 53)
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

  Utils.print_bytes(response)

  -- Close the socket when done
  sock:close()
  print("Socket closed.")
  print("==========================================\n")
  print()


  return Parsing.parse_dns_packet(response)
end

--- Gets the first A record in the Answer section of a DNS packet
-- @param packet The DNS packet to parse from
-- @return The IP address of the record
local function get_answer(packet)
  -- return the first A record in the Answer section
  for i = 1, #packet.answers do
    if packet.answers[i].type == TYPE_A then
      return packet.answers[i].data
    end
  end
end

--- Gets the first A record in the Additionals section of a DNS packet
-- @param packet The DNS packet to parse from
-- @return The IP address of the record
local function get_nameserver_ip(packet)
  -- return the first A record in the Additional section
  for i = 1, #packet.additionals do
    if packet.additionals[i].type == TYPE_A then
      return packet.additionals[i].data
    end
  end
end

--- Gets the first NS record in the Authorities section of a DNS packet
-- @param packet The DNS packet to parse from
-- @return The IP address of the record
local function get_nameserver(packet)
  -- return the first NS record in the Authority section
  for i = 1, #packet.authorities do
    if packet.authorities[i].type == TYPE_NS then
      return packet.authorities[i].data
    end
  end
end

--- Resolves the IP address for a given domain name and record type
-- @param domain_name The domain name to resolve
-- @param record_type The record type to resolve for (A, AAAA, MX, etc.)
-- @return The IP address of the domain
function Resolving.resolve(domain_name, record_type)
  -- Use Google's nameserver ip
  local nameserver = "198.41.0.4"

  -- Initialize helper variables
  local response = nil
  local ip = nil
  local nsIP = nil
  local ns_domain = nil

  -- Keep querying until we get the final IP address
  while true do
    print("Querying " .. nameserver .. " for " .. domain_name)
    response = send_query(nameserver, domain_name, record_type)

    -- Save the first answer's ip
    ip = get_answer(response)

    -- Save the first nameserver's ip from additionals
    nsIP = get_nameserver_ip(response)

    -- Save the first nameserver's domain from authorities
    ns_domain = get_nameserver(response)

    if ip ~= nil then
      print("IP address found! Returning:  " .. ip)
      print()
      return ip
    elseif nsIP ~= nil then
      print("Nameserver IP address found. Replacing current nameserver IP with: " .. nsIP)
      print()
      nameserver = nsIP
    elseif ns_domain ~= nil then
      print("Nameserver domain found. Resolving nameserver IP address for: " .. ns_domain)
      print()
      nameserver = Resolving.resolve(ns_domain, TYPE_A)
    else
      print("Something went wrong...")
      print()
      return ""
    end
  end
end

return Resolving
