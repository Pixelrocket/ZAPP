local function showerror (message)
  native.showAlert("ZilliZ", message, {"OK"},
    function (event)
      if "clicked" == event.action then
        print("error", message)
      end
    end)
end

return showerror