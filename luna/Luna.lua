local receivers = {}
local messenger = {}

-- TODO: implement an optional logging system to show history
messenger.send = function(sender, messageName, payload)
  print("sending: ", messageName, payload, sender)

  for i in ipairs(receivers[messageName]) do
    local listener = receivers[messageName][i]
    if type(listener) == "table" then
      listener[messageName](receivers[messageName][i], payload, sender)
    else
      listener(payload, sender)
    end
  end
end

messenger.isReceiving = function(self, messageName, listener)
  print("isReceiving: ", self, messageName, listener)

  for i in ipairs(receivers[messageName]) do
    if receivers[messageName][i] == listener then
      return true, i
    end
  end
  return false
end

messenger.receive = function(self, messageName, listener)
  print("receive: ", listener, messageName)

  receivers[messageName] = receivers[messageName] or {}
  local bool, i = self:isReceiving(messageName, listener)
  if bool then
    print("already receiving " .. messageName)
  else
    table.insert(receivers[messageName], listener)
  end
end

messenger.stopReceive = function(self, messageName, listener)
  print("stopReceive: ", messageName, listener)
  local bool, i = self:isReceiving(messageName, listener)
  if bool then table.remove(receivers[messageName], i) end
end

local mt = { __index = messenger }

luna = function(path)
  return function(...)
    local actor = require(path)()
    actor.__index = actor
    setmetatable(actor, mt)
    actor:init(unpack(arg))
    return actor
  end
end