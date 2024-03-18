Object = require "classic"
Struct = require "struct"

-- Define the exported DNS object
local DNS = {}

DNS.Header = Object:extend()

function DNS.Header:new(id, flags, num_questions, num_answers, num_authorities, num_additionals)
  self.id = id
  self.flags = flags
  self.num_questions = num_questions or 0
  self.num_answers = num_answers or 0
  self.num_authorities = num_authorities or 0
  self.num_additionals = num_additionals or 0
end

DNS.Question = Object:extend()

function DNS.Question:new(name, type, class)
  self.name = name
  self.type = type
  self.class = class
end

DNS.Record = Object:extend()

function DNS.Record:new(name, type, class, ttl, data)
  self.name = name
  self.type = type
  self.class = class
  self.ttl = ttl
  self.data = data
end

return DNS
