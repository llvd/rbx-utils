local sigcp = {
    {
        FUNCTIONNAME = "CreateProjectile",
        SCRIPTNAME = "Client",
        CONSTANTS = {
            "Sentry Rocket"
        }
    },
    {
        FUNCTIONNAME = "DoProjectile",
        SCRIPTNAME = "Client",
        CONSTANTS = {
            "TickDamage"
        }
    },
    {
        FUNCTIONNAME = "firebullet",
        SCRIPTNAME = "Client",
        CONSTANTS = {
            "ActivateWhenFull",
        }
    },
    {
        FUNCTIONNAME = "reloadwep",
        SCRIPTNAME = "Client",
        CONSTANTS = {
            "equipment",
            "SReload"
        }
    },
    {
        FUNCTIONNAME = "getammo",
        SCRIPTNAME = "Client",
        CONSTANTS = {
            "none",
            "ReloadUpTo"
        }
    },
    {
        FUNCTIONNAME = "setcharacter",
        SCRIPTNAME = "Client",
        CONSTANTS = {
            "mapoverview1",
            "OpenClass"
        }
    }
}

local AutoUpvals = {}
AutoUpvals.__index = AutoUpvals


function AutoUpvals.init(f, obj)
    local self = setmetatable({}, AutoUpvals)
    self.idx = 0
    self.func = f
    self.storeUpvals = {}
    self.upvals = debug.getupvalues(f)

    for i, upval in pairs(self.upvals) do
        if tostring(upval) == tostring(obj) then
            table.insert(self.storeUpvals, i)
        end
    end

    if #self.storeUpvals > 1 then
        self.warnMultUpvalues()
    elseif #self.storeUpvals == 0 then 
		error("Uh oh!")
	else
        self.idx = self.storeUpvals[1]
    end

    return self
end

function AutoUpvals:set(val)
    return debug.setupvalue(self.func, self.idx, val)
end

function AutoUpvals:get()
    return debug.getupvalue(self.func, self.idx)
end

function AutoUpvals:nth(n)
    assert(n > 0 and n <= #self.storeUpvals, "Order out of range.")
    self.idx = self.storeUpvals[n]
end

function AutoUpvals:IsMultUpvals()
    if #storeUpvals > 1 then
        self.warnMultUpvalues()
        return true
    end
    return false
end

function AutoUpvals:warnMultUpvalues()
    warn("FOUND MULTIPLE UPVALUES WITH SAME VALUE AS OBJ: ")
    table.foreach(self.storeUpvals, function(order, index)
        warn("ORDER: " .. order .. "    UPVALUE INDEX: " .. index)
    end)
    warn("SET WHICH UPVALUE TO USE WITH self:nth(order)")
end


function Scanner(siglist) 
    local function doCheck(tbl, val) 
        for i, v in ipairs(tbl) do
            if v == val then
                table.remove(tbl, i)
                return true
            end
        end
    end 

    local function copyTbl(tbl) 
        local new = {}
        for k, v in next, tbl do
            new[k] = v
        end
        return new
    end 

    local function matchConstants(f, consts) 
        assert(#consts ~= 0, "Consts table mustn't be empty")
        local copy = copyTbl(consts)
        for _,v in next, debug.getconstants(f) do
            doCheck(copy, v)
        end

        return #copy == 0
    end

    local function scanf(sig)
        for k,v in next, getgc() do 
            if typeof(v) == 'function' and islclosure(v) then 
                if sig.SCRIPTNAME == getfenv(v).script.Name then
                    if matchConstants(v, sig.CONSTANTS) then
                        return true, v
                    end
                end
            end
        end
        return false
    end

    local function main()
        local result = {}
        for _, fsig in ipairs(siglist) do
            local found, func = scanf(fsig)
            if found then
                print("Found function " .. fsig.FUNCTIONNAME)
                result[fsig.FUNCTIONNAME] = func
            end
        end

        return result
    end

    return main()
end

local result = Scanner(sigcp)

-- for k,v in next, debug.getupvalues(result.reloadwep) do 
-- 	warn(k,v)
-- end
local epic = AutoUpvals.init(result.reloadwep, game:GetService("Players").MahouSama.PlayerGui.GUI.Vitals.Ammo.Clip.Text)
print(epic:get())