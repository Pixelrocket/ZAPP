local EventEmitter = {}

function EventEmitter:new(object)

  object = object or {}
  object._on = {}

  function object:on(event, listener)
    self._on[event] = listener
  end

  function object:emit (event, ...)
    local listener = self._on[event]
    if "function" == type(listener) then
      listener(...)
    end
  end

  return object

end

return EventEmitter