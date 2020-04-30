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

local fenv = getfenv(result.reloadwep)

print(fenv.strafability)
print(fenv.applyvelocity)
print(fenv.speedupdate)