local M = {}

local function add(a, b)
  return a + b
end

function M.greet(name)
  print("Hello, " .. name .. "!")
end

M.sum = add(3, 4)

return M