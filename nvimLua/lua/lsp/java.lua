local home = os.getenv('HOME')


local DEBUGGER_LOCATION = home .. "/.local/share/nvim"
local jdtls = require('jdtls')
local root_markers = { 'gradlew', 'mvnw', '.git', 'pom.xml' }
local root_dir = require('jdtls.setup').find_root(root_markers)
local workspace_folder = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

local remap = require("me.util").remap

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  jdtls.setup_dap({ hotcodereplace = 'auto' })
  jdtls.setup.add_commands()

  -- Default keymaps
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  require("lsp.defaults").on_attach(client, bufnr)

  -- Java extensions
  remap("n", "<C-o>", jdtls.organize_imports, bufopts, "Organize imports")
  remap("n", "<leader>vc", jdtls.test_class, bufopts, "Test class (DAP)")
  remap("n", "<leader>vm", jdtls.test_nearest_method, bufopts, "Test method (DAP)")
  remap("n", "<space>ev", jdtls.extract_variable, bufopts, "Extract variable")
  remap("n", "<space>ec", jdtls.extract_constant, bufopts, "Extract constant")
  remap("v", "<space>em", [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], bufopts, "Extract method")
end

local bundles = {
  vim.fn.glob(
    DEBUGGER_LOCATION .. "/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"
  ),
}
vim.list_extend(bundles, vim.split(vim.fn.glob(DEBUGGER_LOCATION .. "/vscode-java-test/server/*.jar"), "\n"))

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local config = {
  flags = {
    debounce_text_changes = 80,
  },
  capabilities = capabilities,
  on_attach = on_attach,
  init_options = {
    bundles = bundles
  },
  root_dir = root_dir,
  settings = {
    java = {
      format = {
        enabled = true,
        settings = {
          url = vim.fn.stdpath "config" .. "/intellij-java-google-style.xml",
          profile = "GoogleStyle",
        },
      },
      -- format = {
      --   settings = {
      --     url = "/.local/share/eclipse/eclipse-java-google-style.xml",
      --     profile = "GoogleStyle",
      --   },
      -- },
      signatureHelp = { enabled = true },
      contentProvider = { preferred = 'fernflower' },
      completion = {
        favoriteStaticMembers = {
          "org.hamcrest.MatcherAssert.assertThat",
          "org.hamcrest.Matchers.*",
          "org.hamcrest.CoreMatchers.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.mockito.Mockito.*"
        },
        filteredTypes = {
          "com.sun.*",
          "io.micrometer.shaded.*",
          "java.awt.*",
          "jdk.*",
          "sun.*",
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
        },
        hashCodeEquals = {
          useJava7Objects = true,
        },
        useBlocks = true,
      },
      configuration = {
        runtimes = {
          {
            name = "JavaSE-11",
            path = "/Library/Java/JavaVirtualMachines/amazon-corretto-11.jdk/Contents/Home/bin/java",
            -- path = home .. "/Library/Java/JavaVirtualMachines/amazon-corretto-11.jdk/Contents/Home",
          },
          {
            name = "JavaSE-17",
            path = "/Library/Java/JavaVirtualMachines/amazon-corretto-17.jdk/Contents/Home/bin/java",
            -- path = home .. "/Library/Java/JavaVirtualMachines/amazon-corretto-17.jdk/Contents/Home",
          },
          {
            name = "JavaSE-19",
            path = home .. "/opt/homebrew/Cellar/openjdk/19.0.2/libexec/openjdk.jdk/Contents/Home"
          },
        }
      }
    }
  },
  cmd = {

    'java', -- or '/path/to/java17_or_newer/bin/java'
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    -- to enable this one, you have to install the lombok.jar in ~/.local/share/eclipse
    --https://mvnrepository.com/artifact/org.projectlombok/lombok
    '-javaagent:' .. home .. '/.local/share/eclipse/lombok-1.18.26.jar',
    -- 💀
    '-jar', '/opt/homebrew/Cellar/jdtls/1.23.0/libexec/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar',
    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
    -- Must point to the                                                     Change this to
    -- eclipse.jdt.ls installation                                           the actual version
    -- 💀
    '-configuration', '/opt/homebrew/Cellar/jdtls/1.23.0/libexec/config_mac',
    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
    -- Must point to the                      Change to one of `linux`, `win` or `mac`
    -- eclipse.jdt.ls installation            Depending on your system.

    -- 💀
    -- See `data directory configuration` section in the README
    '-data', workspace_folder
  },
}

local M = {}
function M.make_jdtls_config()
  return config
end

return M
