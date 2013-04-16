##Lua
1. Download en pak uit: lua 5.2.2 van [lua.org](http://www.lua.org/ftp/)
2. Edit Makefile, zodat INSTALL_TOP= /usr in plaats van /usr/local
3. make {platform}, bijv. make macosx; type make voor een lijst van mogelijke platforms
4. sudo make install

##LuaRocks
1. Download en pak uit: LuaRocks 2.0.12 van [luarocks.org](http://luarocks.org/releases/)
2. ./configure
3. make
4. sudo make install
5. kopieer luarocks-config.lua naar ~/.luarocks/config.lua

