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