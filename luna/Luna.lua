local receivers = {}
local messenger = {}

-- TODO: implement an optional logging system to show history
messenger.dispatchEvent = function(self, event)
    print("dispatchEvent: ", event.name, event.data, event.target)

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

messenger.hasEventListener = function(self, messageName, listener)
  for i in ipairs(receivers[messageName]) do
    if receivers[messageName][i] == listener then
      return true, i
    end
  end
  return false
end

messenger.addEventListener = function(self, messageName, listener)
  print("addEventListener: ", messageName, listener)

  if listener == nil then listener = self end
  receivers[messageName] = receivers[messageName] or {}
  local bool, i = self:hasEventListener(messageName, listener)
  if bool then
    print("already receiving " .. messageName)
  else
    table.insert(receivers[messageName], listener)
  end
end

messenger.removeEventListener = function(self, messageName, listener)
  print("\nstopReceive: ", messageName, listener)
  local bool, i = self:hasEventListener(messageName, listener)
  if bool then table.remove(receivers[messageName], i) end
end

local mt = { __index = messenger }

luna = function(path)
  return function(...)
    local actor = require(path)()
    setmetatable(actor, mt)
    actor:init(unpack(arg))
    return actor
  end
end