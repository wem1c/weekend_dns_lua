Object = require "classic"
Struct = require "struct"

DNSHeader = Object:extend()

function DNSHeader:new(id, flags, num_questions, num_answers, num_authorities, num_additionals)
  self.id = id
  self.flags = flags
  self.num_questions = num_questions or 0
  self.num_answers = num_answers or 0
  self.num_authorities = num_authorities or 0
  self.num_additionals = num_additionals or 0
end

DNSQuestion = Object:extend()

function DNSQuestion:new(name, type, class)
  self.name = name
  self.type = type
  self.class = class
end

--- Convert a DNS header to binary data
-- @param header The DNS header to convert
-- @return The binary data representing the DNS header
local function header_to_bytes(header)
  local header_fields = { header.id, header.flags, header.num_questions, header.num_answers, header.num_authorities,
    header.num_additionals }

  return Struct.pack(">HHHHHH", table.unpack(header_fields))
end

--- Convert a DNS question to binary data
-- @param question The DNS question to convert
-- @return The binary data representing the DNS question
local function question_to_bytes(question)
  return Struct.pack(">HH", question.type, question.class)
end

--- Encode domain name
-- @param name The domain name to encode
-- @return The encoded domain name
local function encode_domain_name(name)
  local encoded = ""

  -- Iterate over each part of the domain name,
  -- splitting on the '.' character
  for part in string.gmatch(name, "[^.]+") do
    encoded = encoded .. string.char(#part) .. part
  end

  -- Add a null terminator to the end of the encoded name
  return encoded .. "\x00"
end

TYPE_A = 1
CLASS_IN = 1

--- Build a DNS query
-- @param domain_name The domain name to query
-- @param record_type The record type to query
-- @return The binary data representing the DNS query
local function build_query(domain_name, record_type)
  local encoded_name = encode_domain_name(domain_name)
  -- local id = math.random(0, 65535)
  local id = 0x8298
  local RECURSION_DESIRED = 1 << 8

  local header = DNSHeader(id, 1, RECURSION_DESIRED)
  local question = DNSQuestion(encoded_name, record_type, CLASS_IN)

  local header_bytes = header_to_bytes(header)
  local question_bytes = question_to_bytes(question)

  return header_bytes .. question_bytes
end

--- Print string byte per byte, as hexadecimal values
-- @param str The string to print
local function print_bytes(str)
  for i = 1, #str do
    io.write(string.format("%02X ", str:byte(i)))
  end
  io.write("\n")
end
