local function rowcaption (items)
  return function (event)
    local row = event.row
    local text = items[row.id] or "table row " .. row.index
    local rowtext = display.newText(row, text, 0, 0, native.systemFont, 14)
    rowtext.x = 10 + row.x - row.contentWidth / 2 + rowtext.contentWidth / 2
    rowtext.y = row.contentHeight / 2
    rowtext:setTextColor(items.textcolor.r, items.textcolor.g, items.textcolor.b)
  end
end

return rowcaption
