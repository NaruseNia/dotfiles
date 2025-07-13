local exports = {}
local fmt = string.format

function exports.load_conf(name)
  return require(fmt("plugins.config.%s", name))
end

function exports.load_confs(list)
  if type(list) ~= "table" then
    assert("Argument 1 was must be table.")
  end
  local l = {}
  for _, v in ipairs(list) do
    table.insert(l, require(fmt("plugins.config.%s", v)))
  end
  return l
end

return exports
