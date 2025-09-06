local home = os.getenv('HOME')
local DEBUGGER_LOCATION = home .. "/.local/share/nvim"
local eclipse_path_to = '/opt/homebrew/Cellar/jdtls/1.44.0'

local eclipse_path =
-- '/opt/homebrew/Cellar/jdtls/1.44.0/libexec/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar'
'/opt/homebrew/Cellar/jdtls/1.45.0/libexec/plugins/org.eclipse.equinox.launcher_1.6.1000.v20250131-0606.jar'
--
-- '-jar', '/path/to/jdtls_install_location/plugins/org.eclipse.equinox.launcher_VERSION_NUMBER.jar',
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
-- Must point to the                                                     Change this to
-- eclipse.jdt.ls installation                                           the actual version

local config_system = '/opt/homebrew/Cellar/jdtls/1.45.0/libexec/config_mac'
-- '-configuration', '/path/to/jdtls_install_location/config_SYSTEM',
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
-- Must point to the                      Change to one of `linux`, `win` or `mac`
-- eclipse.jdt.ls installation            Depending on your system.

local root_markers = { 'gradlew', 'mvnw', '.git', 'pom.xml' }
local root_dir = require('jdtls.setup').find_root(root_markers)
local workspace_folder = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")


local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)


local jdtls = require('jdtls')
function nnoremap(rhs, lhs, bufopts, desc)
  bufopts.desc = desc
  vim.keymap.set("n", rhs, lhs, bufopts)
end

local on_attach = function(client, bufnr)
  local nvlsp = require "nvchad.configs.lspconfig"
  nvlsp.on_attach(client, bufnr);

  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  nnoremap("<C-o>", jdtls.organize_imports, bufopts, "Organize imports")
  nnoremap("<space>ev", jdtls.extract_variable, bufopts, "Extract variable")
  nnoremap("<space>ec", jdtls.extract_constant, bufopts, "Extract constant")
  vim.keymap.set('v', "<space>em", [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
    { noremap = true, silent = true, buffer = bufnr, desc = "Extract method" })


  jdtls.setup_dap({ hotcodereplace = 'auto' })
  jdtls.setup.add_commands()

  -- Java extensions
  nnoremap("<leader>tc", jdtls.test_class, bufopts, "Test class (DAP)")
  nnoremap("<leader>tm", jdtls.test_nearest_method, bufopts, "Test method (DAP)")
end


local bundles = {
  vim.fn.glob(
    DEBUGGER_LOCATION .. "/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"
  ),
}
vim.list_extend(bundles, vim.split(vim.fn.glob(DEBUGGER_LOCATION .. "/vscode-java-test/server/*.jar"), "\n"))

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
  flags = {
    debounce_text_changes = 80,
  },
  on_attach = on_attach,
  init_options = {
    bundles = bundles
  },
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {

    -- 💀
    -- 'java', -- or '/path/to/java21_or_newer/bin/java'
    '/opt/homebrew/Cellar/openjdk@21/21.0.3/bin/java',

    -- depends on if `java` is in your $PATH env variable and if it points to the right version.

    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

    -- 💀
    '-jar', eclipse_path,
    -- '-jar', '/path/to/jdtls_install_location/plugins/org.eclipse.equinox.launcher_VERSION_NUMBER.jar',
    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
    -- Must point to the                                                     Change this to
    -- eclipse.jdt.ls installation                                           the actual version


    -- 💀
    '-configuration', config_system,
    -- '-configuration', '/path/to/jdtls_install_location/config_SYSTEM',
    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
    -- Must point to the                      Change to one of `linux`, `win` or `mac`
    -- eclipse.jdt.ls installation            Depending on your system.


    -- 💀
    -- See `data directory configuration` section in the README
    '-data', workspace_folder
  },

  -- 💀
  -- This is the default if not provided, you can remove it. Or adjust as needed.
  -- One dedicated LSP server & client will be started per unique root_dir
  --
  -- vim.fs.root requires Neovim 0.10.
  -- If you're using an earlier version, use: require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}),
  root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew" }),

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
      eclipse = {
        downloadSources = true,
      },
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
        -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
        -- And search for `interface RuntimeOption`
        -- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
        runtimes = {
          {
            name = "JavaSE-11",
            path = "/Library/Java/JavaVirtualMachines/amazon-corretto-11.jdk/Contents/Home"
          },
          {
            name = "JavaSE-17",
            path = "/opt/homebrew/Cellar/openjdk@17/17.0.14/libexec/openjdk.jdk/Contents/Home"
            -- path = "/Library/Java/JavaVirtualMachines/amazon-corretto-17.jdk/Contents/Home"
          },
          {
            name = "JavaSE-21",
            path = "/opt/homebrew/Cellar/openjdk@21/21.0.3/libexec/openjdk.jdk/Contents/Home"
            -- path ="/Library/Java/JavaVirtualMachines/amazon-corretto-21.jdk/Contents/Home"
          },
        }
      }
    }
  },

  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  --
}
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)
