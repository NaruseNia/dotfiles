local exports = {}

function exports.is_windows_native()
  return (vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1) and vim.fn.has("wsl") ~= 1
end

function exports.is_windows()
  return vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
end

function exports.is_wsl()
  return vim.fn.has("wsl") == 1
end

function exports.is_mac()
  return vim.fn.has("mac") == 1
end

function exports.is_linux()
  return vim.fn.has("linux") == 1
end

function exports.is_unix()
  return exports.is_mac() or exports.is_linux() or exports.is_wsl()
end

function exports.is_bsd()
  return vim.fn.has("bsd") == 1
end

function exports.is_sun()
  return vim.fn.has("sun") == 1
end

return exports
