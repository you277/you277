local function hypernull(callback, ...)
    local v = true
    task.spawn(function()
        v = false
    end)
    if v then
        return callback(...)
    end
    hypernull(callback, ...)
end

return hypernull