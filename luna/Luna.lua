local function createMessenger()
  local receivers = {}
  local messenger = {}

  -- TODO: implement an optional logging system to show history
  messenger.dispatchEvent = function(self, event)
  --    print("dispatchEvent: ", "name = ", event.name, "data = ", event.data, "target = ", event.target)

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
    listener = listener or self

    for i in ipairs(receivers[messageName]) do
      if receivers[messageName][i] == listener then
        return true, i
      end
    end
    return false
  end

  messenger.addEventListener = function(self, messageName, listener)
--    print("addEventListener: ", messageName, listener)

    listener = listener or self
    receivers[messageName] = receivers[messageName] or {}
    local bool, i = self:hasEventListener(messageName, listener)
    if bool then
      print("already receiving " .. messageName)
    else
      table.insert(receivers[messageName], listener)
    end
  end

  messenger.removeEventListener = function(self, messageName, listener)
  --    print("\nstopReceive: ", messageName, listener)
    listener = listener or self
    local bool, i = self:hasEventListener(messageName, listener)
    if bool then table.remove(receivers[messageName], i) end
  end

  return messenger
end


local lunaContext = {}
lunaContext.messenger = {}
local function extend(destination, source)
  for k, v in pairs(source) do
    destination[k] = v
  end

  return destination
end

extend(lunaContext.messenger, createMessenger())

luna = function(path, context)
  if context == nil then
    context = lunaContext
  elseif context.messenger == nil then
    context.messenger = {}
    extend(context.messenger, createMessenger())
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

  extend(actor, context.messenger)

  return actor
end