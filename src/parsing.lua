-- Import modules
local DNS      = require "src.dns"
local Decoding = require "src.decoding"
local Reader   = require "src.modules.reader"

-- Define module variable
local Parsing  = {}

--- Parse DNS header binary data
-- @param reader Reader object with response data loaded
-- @return Decoded DNS Header object
function Parsing.parse_header(reader)
  return DNS.Header(string.unpack(">HHHHHH", reader:read(12)))
end

--- Parse DNS question binary data
-- @param reader Reader object with response data loaded
-- @return Decoded DNS Question object
function Parsing.parse_question(reader)
  -- Get the decoded name and the remaning question bytes
  local decoded_name = Decoding.decode_name_simple(reader)

  -- Get the type and class from the first 4 bytes of the remaining question bytes
  local type, class = string.unpack(">HH", reader:read(4))

  -- Return the DNS question and the remaining bytes
  return DNS.Question(decoded_name, type, class)
end

--- Parse DNS record binary data
-- @param reader Reader object with response data loaded
-- @return DNS.Record
function Parsing.parse_record(reader)
  -- Get the decodeed the name
  local decoded_name = Decoding.decode_name(reader)

  -- Unpack the type, class, ttl and data length from the first 10 bytes of the remaining data
  local type, class, ttl, data_len = string.unpack(">HHIH", reader:read(10))

  -- Read the record data bytes based on the unpacked data_len value
  local data = reader:read(data_len)

  -- Return a DNS Record object based on the decoded/unpacked values
  return DNS.Record(decoded_name, type, class, ttl, data)
end

--- Parse DNS packet binary data
-- @param data - DNS packet byte data
-- @return DNS.Packet
function Parsing.parse_dns_packet(data)
  -- Initialize reader object with the data
  local reader = Reader.new(data)

  -- Parse the header
  local header = Parsing.parse_header(reader)

  -- Parse the questions
  local questions = {}
  for i = 1, header.num_questions do
    questions[i] = Parsing.parse_question(reader)
  end

  -- Parse the answers
  local answers = {}
  for i = 1, header.num_answers do
    answers[i] = Parsing.parse_record(reader)
  end

  -- Parse the authorities
  local authorities = {}
  for i = 1, header.num_authorities do
    authorities[i] = Parsing.parse_record(reader)
  end

  -- Parse the additionals
  local additionals = {}
  for i = 1, header.num_additionals do
    additionals[i] = Parsing.parse_record(reader)
  end

  return DNS.Packet(header, questions, answers, authorities, additionals)
end

return Parsing
