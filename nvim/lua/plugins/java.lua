-- jdtls itself needs Java 25+, while projects build on Java 21 (both installed via mise).
local function mise_java(version)
  local out = vim.fn.system({ "mise", "where", "java@" .. version })
  return vim.v.shell_error == 0 and vim.trim(out) or nil
end

return {
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      local jdk25 = mise_java("corretto-25")
      if jdk25 then
        table.insert(opts.cmd, "--java-executable=" .. jdk25 .. "/bin/java")
      end
      local jdk21 = mise_java("corretto-21")
      if jdk21 then
        opts.settings.java.configuration = {
          runtimes = { { name = "JavaSE-21", path = jdk21, default = true } },
        }
      end
    end,
  },
}
