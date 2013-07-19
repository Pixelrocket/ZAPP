local function showerror (message)
  native.showAlert("zAPP", message, {"OK"},
    function (event)
      if "clicked" == event.action then
        print("error", message)
      end
    end)
end

return showerror