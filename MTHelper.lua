assert(not getgenv().mtloaded, "Another instance is running")
local backup = {}
local ishookset = false
getgenv().mtloaded = true

function isvalidmetamethod(method)
  local valid = {"__namecall", "__index", "__newindex"}
  for _, m in next, valid do
    if m == method then
      return true
    end
  end
  return false
end

function getgamemt()
  local mt = getrawmetatable(game)
  setreadonly(mt, false)
  return mt
end

function hookmetamethod(method, func)
  print("HOOKING")
  assert(isvalidmetamethod(method), "Invalid metamethod!")
  local mt = getgamemt()
  if backup[method] == nil then 
    backup[method] = mt[method]
  end 
  if ishookset then
    restoremetamethod(method)
    mt = getgamemt()
  end
  local newfunc = func(mt[method])
  mt[method] = newfunc
  ishookset = true
  print("HOOKED")
end

function restoremetamethod(method)
  if backup[method] then
    local mt = getgamemt()
    mt[method] = backup[method]
  end
  ishookset = false
end

getgenv().hookmetamethod = hookmetamethod
getgenv().restoremetamethod = restoremetamethod

print("Module: MTHelper loaded")