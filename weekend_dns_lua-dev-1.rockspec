package = "weekend_dns_lua"
version = "dev-1"
source = {
   url = "https://github.com/wem1c/weekend_dns_lua"
}
description = {
   homepage = "https://github.com/wem1c/weekend_dns_lua",
   license = "MIT"
}
dependencies = {
   "lua ~> 5.4",
   "luasocket ~> 3.0.0"
}
build = {
   type = "builtin",
   modules = {}
}
