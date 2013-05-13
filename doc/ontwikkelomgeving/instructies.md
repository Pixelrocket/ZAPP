##1. Build tools

###Linux
1. `sudo apt-get update`
2. `sudo apt-get install build-essential`

###OSX:
1. Installeer XCode vanuit de App Store
2. Open XCode, ga naar Preferences, Tabblad Downloads, Installeer `Command Line Tools`

##2. Sublime Text
Download en installeer [Sublime Text 2](http://www.sublimetext.com/2)

##3. Lua
1. Download en pak uit: lua 5.2.2 van [lua.org](http://www.lua.org/ftp/)
2. Edit `Makefile`, zodat `INSTALL_TOP= /usr` in plaats van `/usr/local`
3. `make macosx` of `make linux`
4. `sudo make install`

##4. LuaRocks
1. Download en pak uit: LuaRocks 2.0.12 van [luarocks.org](http://luarocks.org/releases/)
2. `./configure`
3. `make`
4. `sudo make install`
5. Kopieer [`luarocks-config.lua`](https://github.com/Pixelrocket/ZAPP/blob/master/doc/ontwikkelomgeving/luarocks-config.lua) naar `~/.luarocks/config.lua`

##5. Sublime Lua Dev
1. Ga naar de [LuaSublime](https://github.com/rorydriscoll/LuaSublime) repository op github
2. Klik op de ZIP knop om de bestanden te downloaden en pak ze uit

###OSX
3. Open Sublime, kies File | Open... en kies je thuismap (Shift+Cmd+H)
4. In de sidebar, klap open: `~/Library/Application Support/Sublime Text 2/Packages/Lua`
5. Ctrl+Klik op de eerste file in die `Lua` directory en kies `Reveal in Finder`
6. Bewaar wat daar staat als backup in een nieuw mapje
7. Kopieer de gedownloade bestanden

##6. Corona SDK
###OSX
Download en installeer de OSX-versie via [Corona Labs](http://www.coronalabs.com/products/corona-sdk/)
###Linux
Download de Windows-versie via [Corona Labs](http://www.coronalabs.com/products/corona-sdk/) en installeer via [Wine](http://www.winehq.org/)
