--[[

  This is a toy implementation of a DNS resolver in Lua.

  It is a weekend project rewrite from Python by Conor
  C. Peterson (wem1c), based on a Wizard Zines tutorial
  written by Julia Evans. <3

  See: https://implement-dns.wizardzines.com/

  ]]

-- Import custom modules
local Resolving   = require "src.resolving"

-- Define record type constants
TYPE_A            = 1
TYPE_TXT          = 16
TYPE_NS           = 2

-- Define class constant
CLASS_IN          = 1

-- Define flag constants
FLAGS             = 1 -- recursion desired (when asking a DNS caching server)
--FLAGS           = 0 -- recursion not desired (when asking a DNS server directly)

-- TODO: www.facebook.com isn't parsed correctly.
-- "But I’ll leave those as a puzzle for you to solve if you want (hint: look at the record type!)"
-- See: https://implement-dns.wizardzines.com/book/part_2#test-out-all-our-code

local resolved_ip = Resolving.resolve('conor.zone', TYPE_A)
print(resolved_ip)

-- TODO: implement additional Exercises
-- See: https://implement-dns.wizardzines.com/book/exercises
