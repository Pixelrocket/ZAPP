local function rowcaption (items, r, g, b, font)
  return function (event)
    local row = event.row
    local item = items[row.id] or {text = nil}
    item.index = row.index -- needed as the prameter for TableViewWidget:deleteRow()
    local text = item.text or "table row " .. row.index
    local size, r, g, b = 18, r, g, b
    if row.isCategory then
        local factor = .8
        size = size * factor
        r, g, b = r * factor, g * factor, b * factor
    end
    local rowtext = display.newText(row, text, 0, 0, (font or native.systemFont), size)
    rowtext.x = 10 + row.x - row.contentWidth / 2 + rowtext.contentWidth / 2
    rowtext.y = row.contentHeight / 2
    rowtext:setTextColor(r, g, b)
    if row.isCategory then
      local hr = display.newRect(row, 0, 1 + rowtext.y + rowtext.contentHeight / 2, row.contentWidth - 30, 1)
      hr.x = 10 + row.x - row.contentWidth / 2 + hr.contentWidth / 2
      hr:setFillColor(r, g, b, 255)
    end
  end
end

return rowcaption
