-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
-- If you started neovim within `~/dev/xy/project-1` this would resolve to `project-1`
local home = os.getenv 'HOME'
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = home .. '/.local/share/jdtls/workspace' .. project_name

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local java_debug_path = vim.fn.stdpath 'data' .. '/mason/packages/java-debug-adapter/'
local java_test_path = vim.fn.stdpath 'data' .. '/mason/packages/java-test/'
local jdtls_path = vim.fn.stdpath 'data' .. '/mason/packages/jdtls/'

local bundles = {
  vim.fn.glob(java_debug_path .. 'extension/server/com.microsoft.java.debug.plugin-*.jar', true),
}
vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_path .. 'extension/server/*.jar', true), '\n'))
local extendedClientCapabilities = require('jdtls').extendedClientCapabilities

local config = {
  cmd = {
    'java', -- or '/path/to/java17_or_newer/bin/java'
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',
    '-jar',
    home .. '/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar',
    '-configuration',
    jdtls_path .. 'config_linux',
    '-data',
    workspace_dir,
  },
  root_dir = vim.fs.root(0, { '.git', 'mvnw', 'gradlew' }),

  settings = {
    java = {
      signatureHelp = { enabled = true },
      extendedClientCapabilities = extendedClientCapabilities,
      maven = {
        downloadSources = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      inlayHints = {
        parameterNames = {
          enabled = 'all', -- literals, all, none
        },
      },
      format = {
        enabled = false,
      },
    },
  },
  capabilities = capabilities,
  --  debugger
  init_options = {
    settings = {
      java = {
        implementationsCodeLens = { enabled = true },
        imports = { -- <- this
          gradle = {
            enabled = true,
            wrapper = {
              enabled = true,
              checksums = {
                {
                  sha256 = '81a82aaea5abcc8ff68b3dfcb58b3c3c429378efd98e7433460610fecd7ae45f',
                  allowed = true,
                },
              },
            },
          },
        },
      },
    },
    bundles = bundles,
  },
}
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)
