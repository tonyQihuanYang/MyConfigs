local home = os.getenv('HOME')
local DEBUGGER_LOCATION = home .. "/.local/share/nvim"

-- Auto-detect jdtls paths (works across brew versions)
local jdtls_dir = vim.fn.trim(vim.fn.system("brew --prefix jdtls")) .. "/libexec"
local eclipse_path = vim.fn.glob(jdtls_dir .. "/plugins/org.eclipse.equinox.launcher_*.jar")
local config_system = jdtls_dir .. (vim.fn.has("mac") == 1 and "/config_mac" or "/config_linux")

-- Auto-detect Java home for running jdtls
local java_cmd = vim.fn.trim(vim.fn.system("brew --prefix openjdk@21")) .. "/bin/java"
if vim.fn.executable(java_cmd) ~= 1 then
  java_cmd = "java"
end

-- Auto-detect Java runtimes
local function find_java(name, candidates)
  for _, path in ipairs(candidates) do
    local expanded = vim.fn.glob(path)
    if expanded ~= "" and vim.fn.isdirectory(expanded) == 1 then
      return { name = name, path = expanded }
    end
  end
  return nil
end

local runtimes = {}
local runtime_candidates = {
  { "JavaSE-11", {
    vim.fn.glob("/opt/homebrew/Cellar/openjdk@11/*/libexec/openjdk.jdk/Contents/Home"),
    "/Library/Java/JavaVirtualMachines/amazon-corretto-11.jdk/Contents/Home",
  }},
  { "JavaSE-17", {
    vim.fn.glob("/opt/homebrew/Cellar/openjdk@17/*/libexec/openjdk.jdk/Contents/Home"),
    "/Library/Java/JavaVirtualMachines/amazon-corretto-17.jdk/Contents/Home",
  }},
  { "JavaSE-21", {
    vim.fn.glob("/opt/homebrew/Cellar/openjdk@21/*/libexec/openjdk.jdk/Contents/Home"),
    "/Library/Java/JavaVirtualMachines/amazon-corretto-21.jdk/Contents/Home",
  }},
}
for _, entry in ipairs(runtime_candidates) do
  local rt = find_java(entry[1], entry[2])
  if rt then table.insert(runtimes, rt) end
end

local root_markers = { 'gradlew', 'mvnw', '.git', 'pom.xml' }
local root_dir = require('jdtls.setup').find_root(root_markers)
local workspace_folder = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local jdtls = require('jdtls')
local function nnoremap(rhs, lhs, bufopts, desc)
  bufopts.desc = desc
  vim.keymap.set("n", rhs, lhs, bufopts)
end

local on_attach = function(client, bufnr)
  local nvlsp = require "nvchad.configs.lspconfig"
  nvlsp.on_attach(client, bufnr)

  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  nnoremap("<C-o>", jdtls.organize_imports, bufopts, "Organize imports")
  nnoremap("<space>ev", jdtls.extract_variable, bufopts, "Extract variable")
  nnoremap("<space>ec", jdtls.extract_constant, bufopts, "Extract constant")
  vim.keymap.set('v', "<space>em", [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
    { noremap = true, silent = true, buffer = bufnr, desc = "Extract method" })

  jdtls.setup_dap({ hotcodereplace = 'auto' })
  jdtls.setup.add_commands()

  nnoremap("<leader>tc", jdtls.test_class, bufopts, "Test class (DAP)")
  nnoremap("<leader>tm", jdtls.test_nearest_method, bufopts, "Test method (DAP)")
end

-- Extension bundles (debug + test)
local bundles = {
  vim.fn.glob(
    DEBUGGER_LOCATION .. "/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"
  ),
}
local test_jars = vim.split(vim.fn.glob(DEBUGGER_LOCATION .. "/vscode-java-test/server/*.jar"), "\n")
for _, jar in ipairs(test_jars) do
  if not vim.endswith(jar, "com.microsoft.java.test.runner-jar-with-dependencies.jar")
    and not vim.endswith(jar, "jacocoagent.jar") then
    table.insert(bundles, jar)
  end
end

local config = {
  flags = { debounce_text_changes = 80 },
  on_attach = on_attach,
  init_options = { bundles = bundles },
  cmd = {
    java_cmd,
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '-jar', eclipse_path,
    '-configuration', config_system,
    '-data', workspace_folder,
  },
  root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew" }),
  settings = {
    java = {
      eclipse = { downloadSources = true },
      format = {
        enabled = true,
        settings = {
          url = vim.fn.stdpath "config" .. "/intellij-java-google-style.xml",
          profile = "GoogleStyle",
        },
      },
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
          "org.mockito.Mockito.*",
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
        organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 },
      },
      codeGeneration = {
        toString = { template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}" },
        hashCodeEquals = { useJava7Objects = true },
        useBlocks = true,
      },
      configuration = { runtimes = runtimes },
    },
  },
}

require('jdtls').start_or_attach(config)
