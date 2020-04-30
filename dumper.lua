-- TODO: Complete dumper

local CacheManager = {}


function CacheManager.new() 
    local self = {
        cache = {}
    }

    self.isNewFunction = function(f)
        for cf, ref in pairs(cache) do
            if (tostring(f) == cf) then 
                return false, ref
            end
        end
        return true
    end

    self.cacheFunction = function(f, data) 
        if not self.isNewFunction(f) then
            self.cache[tostring(f)] = data
        end
    end

    self.getFunctionData = function(f) 
        return cache[tostring(f)]
    end 

    return self
end

function FunctionBuilder()
    local cm = CacheManager.new()

    local function init(f)
        local data = {
            CONSTANTS = {},
            GLOBALS = {},
            UPVALUES = {}
        }

        setmetatable(data, {
            __newindex = function(t, k, v) 
                if (typeof(k) ~= "string" or typeof(v) ~= "string") then
                    error("Unable to insert non-string data")
                end
                rawset(t, k, v)
            end
        })
    
        local function cleanupData() 
            for k, v in pairs(data) do
                if v.length == 0 then
                    data[k] = nil 
                end
            end
        end
    
        local function getConstants()
            local _constants = debug.getconstants(f)
            -- optimiziation
            for i = 1, #_constants do
                local current = _constants[i]
                if typeof(current) == "function" then

                else
                    table.insert(data.CONSTANTS)
                end
            end
        end

    end

    return init
end

function TableBuilder() 

end