local main = system.pathForFile("main.lua", system.ResourceDirectory)
local dir = string.sub(main, 1, #main - 8)
package.path = dir .. "share/lua/5.2/?.lua;" .. package.path
package.path = dir .. "share/lua/5.2/?/init.lua;" .. package.path
