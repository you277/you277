--
-- Supernull, old Hypernull (bindableHypernull), and Hypernull
--

local function recurse(depth, callback, ...)
    if depth == 80 then -- max defer depth
        return callback(...)
    end
    task.defer(recurse, depth + 1, callback, ...)
end

local function supernull(callback, ...)
    recurse(0, callback, ...)
end

-- cause a c stack overflow so that events from property changes do not fire
local function hypernull(callback, ...)
    local v = true
    task.spawn(function()
        v = false
    end)
    if v then
        return callback(...)
    end
   task.spawn(hypernull, callback, ...)
end

-- original variant of hypernull
local bindable = Instance.new("BindableFunction")
local invoke = bindable.Invoke
bindable.OnInvoke = function(callback, ...)
    if not pcall(invoke, bindable, callback, ...) then
        callback(...)
    end
end

local function bindableHypernull(callback, ...)
    invoke(bindable, callback, ...)
end

return {
    HN = hypernull,
    BHN = bindableHypernull,
    SN = supernull,
}
