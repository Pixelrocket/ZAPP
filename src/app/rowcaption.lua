local function rowcaption (items, r, g, b)
  return function (event)
    local row = event.row
    local item = items[row.id] or {text = nil}
    item.index = row.index -- needed as the prameter for TableViewWidget:deleteRow()
    print("\n")
    print(row.id)
    for k,v in pairs(items) do
      print(k,v)
    end
    local text = item.text or "table row " .. row.index
    local rowtext = display.newText(row, text, 0, 0, native.systemFont, 14)
    rowtext.x = 10 + row.x - row.contentWidth / 2 + rowtext.contentWidth / 2
    rowtext.y = row.contentHeight / 2
    rowtext:setTextColor(r, g, b)
  end
end

return rowcaption
