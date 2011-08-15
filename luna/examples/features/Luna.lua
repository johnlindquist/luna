lunaDebug = false

EventDispatcher = function()
  local o = {}
  local receivers = {}
  local removedReceivers = {}

  o.dispatchEvent = function(self, event)
    if lunaDebug then
      print("dispatchEvent: ", "name = ", event.name, "data = ", event.data, "target = ", event.target)
    end

    if receivers[event.name] == nil then return end
    for i in ipairs(receivers[event.name]) do
      local listener = receivers[event.name][i]
      if type(listener) == "table" then
        listener[event.name](receivers[event.name][i], event)
      else
        listener(event)
      end
    end
  end

  o.hasEventListener = function(self, messageName, listener)
    listener = listener or self

    if receivers[messageName] == nil then return false end
    for i in ipairs(receivers[messageName]) do
      if receivers[messageName][i] == listener then
        return true, i
      end
    end
    return false
  end

  o.addEventListener = function(self, messageName, listener)
    if lunaDebug then
      print("addEventListener: ", messageName, listener)
    end

    listener = listener or self
    receivers[messageName] = receivers[messageName] or {}
    local bool, i = self:hasEventListener(messageName, listener)
    if bool then
      print("already receiving " .. messageName)
    else
      table.insert(receivers[messageName], listener)
    end
  end

  o.removeEventListener = function(self, messageName, listener)
    if lunaDebug then
      print("\nremoveEventListener: ", messageName, listener)
    end

    listener = listener or self
    local bool, i = self:hasEventListener(messageName, listener)
    if bool then table.remove(receivers[messageName], i) end
  end

  o.removeAllEventListeners = function(self)
    for k, v in pairs(receivers) do
      removedReceivers[k] = receivers[k]
      receivers[k] = nil
    end
  end

  o.addAllRemovedEventListeners = function(self)
    for k, v in pairs(removedReceivers) do
      receivers[k] = removedReceivers[k]
      removedReceivers[k] = nil
    end

  end

  return o
end

local function extend(destination, source)
  for k, v in pairs(source) do
    destination[k] = v
  end

  return destination
end

lunaEventDispatcher = EventDispatcher()

luna = function(path, eventDispatcher)
  if eventDispatcher == nil then
    eventDispatcher = lunaEventDispatcher
  elseif eventDispatcher == nil then
    eventDispatcher = EventDispatcher()
  end
  local actor
  if type(path) == "table" then
    actor = path
  else
    actor = require(path)
    if type(actor) == "function" then
      actor = actor()
    end
  end

  setmetatable(actor, {
    __call = function(...)
      if actor.init then
        actor.init(unpack(arg))
      end
      return actor
    end
  })

  extend(actor, eventDispatcher)

  return actor
end
