-- ~/.config/nvim/lua/tacovim/plugins/debugging.lua
-- TacoVim Debugging and DAP Configuration

return {
  -- =============================================================================
  -- DAP - DEBUG ADAPTER PROTOCOL
  -- =============================================================================
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neodev/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
      "jay-babu/mason-nvim-dap.nvim",
      "nvim-telescope/telescope-dap.nvim",
      -- Language specific DAP plugins
      "mfussenegger/nvim-dap-python",
      "leoluz/nvim-dap-go",
      "mxsdev/nvim-dap-vscode-js",
    },
    keys = {
      -- Visual Studio style debugging controls
      { "<F5>", function() require("dap").continue() end, desc = "🚀 Debug: Start/Continue" },
      { "<S-F5>", function() require("dap").terminate() end, desc = "⏹️ Debug: Stop" },
      { "<C-S-F5>", function() require("dap").restart() end, desc = "🔄 Debug: Restart" },
      { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "🔴 Debug: Toggle Breakpoint" },
      { "<F10>", function() require("dap").step_over() end, desc = "⏭️ Debug: Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "⬇️ Debug: Step Into" },
      { "<S-F11>", function() require("dap").step_out() end, desc = "⬆️ Debug: Step Out" },

      -- Advanced breakpoints
      { 
        "<leader>dB", 
        function() 
          require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) 
        end, 
        desc = "🎯 Conditional Breakpoint" 
      },
      { 
        "<leader>dL", 
        function() 
          require("dap").set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) 
        end, 
        desc = "📝 Log Point" 
      },
      { "<leader>dC", function() require("dap").clear_breakpoints() end, desc = "🧹 Clear All Breakpoints" },

      -- UI and session control
      { "<leader>du", function() require("dapui").toggle() end, desc = "🔧 Toggle Debug UI" },
      { "<leader>dr", function() require("dap").repl.open() end, desc = "💬 Debug Console" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "🔄 Run Last Debug Session" },
      
      -- Variable inspection
      {
        "<leader>dh",
        function()
          require("dap.ui.widgets").hover()
        end,
        desc = "🔍 Hover Variables"
      },
      {
        "<leader>dp",
        function()
          require("dap.ui.widgets").preview()
        end,
        desc = "👁️ Preview"
      },
      {
        "<leader>df",
        function()
          local widgets = require('dap.ui.widgets')
          widgets.centered_float(widgets.frames)
        end,
        desc = "📚 Call Stack"
      },
      {
        "<leader>ds",
        function()
          local widgets = require('dap.ui.widgets')
          widgets.centered_float(widgets.scopes)
        end,
        desc = "🎯 Scopes"
      },

      -- Telescope integration
      { "<leader>dbb", function() require("telescope").extensions.dap.list_breakpoints() end, desc = "📋 List Breakpoints" },
      { "<leader>dvv", function() require("telescope").extensions.dap.variables() end, desc = "📊 Variables" },
      { "<leader>dff", function() require("telescope").extensions.dap.frames() end, desc = "📚 Frames" },
      { "<leader>dcc", function() require("telescope").extensions.dap.commands() end, desc = "🎛️ Commands" },
      { "<leader>dco", function() require("telescope").extensions.dap.configurations() end, desc = "⚙️ Configurations" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- DAP UI setup with enhanced configuration
      dapui.setup({
        icons = { 
          expanded = "▾", 
          collapsed = "▸", 
          current_frame = "▸" 
        },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        element_mappings = {
          stacks = {
            open = "<CR>",
            expand = "o",
          }
        },
        layouts = {
          {
            elements = {
              "scopes",
              "breakpoints", 
              "stacks",
              "watches",
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              "repl",
              "console",
            },
            size = 0.25,
            position = "bottom",
          },
        },
        controls = {
          enabled = true,
          element = "repl",
          icons = {
            pause = "⏸",
            play = "▶",
            step_into = "⏬",
            step_over = "⏭",
            step_out = "⏫",
            step_back = "⏮",
            run_last = "↻",
            terminate = "⏹",
            disconnect = "⏏",
          },
        },
        floating = {
          max_height = 0.8,
          max_width = 0.8,
          border = "rounded",
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
        windows = { indent = 1 },
        render = {
          max_type_length = nil,
          max_value_lines = 100,
        }
      })

      -- Enhanced virtual text configuration
      require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        only_first_definition = true,
        all_references = false,
        clear_on_continue = false,
        display_callback = function(variable, buf, stackframe, node, options)
          if options.virt_text_pos == 'inline' then
            return ' = ' .. variable.value
          else
            return variable.name .. ' = ' .. variable.value
          end
        end,
        virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',
        all_frames = false,
        virt_lines = false,
        virt_text_win_col = nil
      })

      -- Auto-open/close UI with error handling
      dap.listeners.after.event_initialized["dapui_config"] = function()
        pcall(function() dapui.open() end)
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        pcall(function() dapui.close() end)
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        pcall(function() dapui.close() end)
      end

      -- Setup telescope-dap integration
      pcall(function()
        require('telescope').load_extension('dap')
      end)

      -- Enhanced breakpoint signs
      vim.fn.sign_define('DapBreakpoint', { 
        text = '🔴', 
        texthl = 'DapBreakpoint', 
        linehl = '', 
        numhl = '' 
      })
      vim.fn.sign_define('DapBreakpointCondition', {
        text = '🎯',
        texthl = 'DapBreakpointCondition',
        linehl = '',
        numhl = ''
      })
      vim.fn.sign_define('DapLogPoint', { 
        text = '📝', 
        texthl = 'DapLogPoint', 
        linehl = '', 
        numhl = '' 
      })
      vim.fn.sign_define('DapStopped', { 
        text = '▶️', 
        texthl = 'DapStopped', 
        linehl = 'DapStoppedLine', 
        numhl = '' 
      })
      vim.fn.sign_define('DapBreakpointRejected', {
        text = '❌', 
        texthl = 'DapBreakpointRejected', 
        linehl = '', 
        numhl = '' 
      })

      -- Custom highlight groups
      vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = '#e51400' })
      vim.api.nvim_set_hl(0, 'DapBreakpointCondition', { fg = '#f79000' })
      vim.api.nvim_set_hl(0, 'DapLogPoint', { fg = '#61afef' })
      vim.api.nvim_set_hl(0, 'DapStopped', { fg = '#ffcc00' })
      vim.api.nvim_set_hl(0, 'DapStoppedLine', { bg = '#2e3440' })

      -- =============================================================================
      -- ADAPTER CONFIGURATIONS
      -- =============================================================================

      -- LLDB/CodeLLDB for C/C++/Rust/Zig
      dap.adapters.codelldb = {
        type = 'server',
        port = "${port}",
        executable = {
          command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
          args = { "--port", "${port}" },
        }
      }

      -- Node.js adapter
      dap.adapters.node2 = {
        type = 'executable',
        command = 'node',
        args = { vim.fn.stdpath("data") .. "/mason/packages/node-debug2-adapter/out/src/nodeDebug.js" },
      }

      -- Chrome adapter
      dap.adapters.chrome = {
        type = "executable",
        command = "node",
        args = { vim.fn.stdpath("data") .. "/mason/packages/chrome-debug-adapter/out/src/chromeDebug.js" }
      }

      -- =============================================================================
      -- LANGUAGE CONFIGURATIONS
      -- =============================================================================

      -- Rust
      dap.configurations.rust = {
        {
          name = "Launch Rust Binary",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = {},
          runInTerminal = false,
        },
        {
          name = "Launch Rust Binary (Release)",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/release/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = {},
          runInTerminal = false,
        },
      }

      -- C/C++
      dap.configurations.cpp = {
        {
          name = "Launch C++ Binary",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/build/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = {},
          runInTerminal = false,
        },
        {
          name = "Launch C++ Binary (Debug)",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/build/Debug/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = {},
          runInTerminal = false,
        },
      }
      dap.configurations.c = dap.configurations.cpp

      -- Zig
      dap.configurations.zig = {
        {
          name = "Launch Zig Binary",
          type = "codelldb",
          request = "launch",
          program = function()
            local bin_dir = vim.fn.getcwd() .. '/zig-out/bin'
            if vim.fn.isdirectory(bin_dir) == 0 then
              vim.notify("❌ Zig binary directory not found. Run 'zig build' first.", vim.log.levels.WARN)
              return nil
            end
            return vim.fn.input('Path to executable: ', bin_dir .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = {},
          runInTerminal = false,
          sourceLanguages = { "zig" },
        },
        {
          name = "Build and Launch Zig",
          type = "codelldb", 
          request = "launch",
          program = function()
            -- Auto-build before debugging
            vim.notify("🔨 Building Zig project...", vim.log.levels.INFO)
            local result = vim.fn.system("zig build")
            if vim.v.shell_error ~= 0 then
              vim.notify("❌ Build failed: " .. result, vim.log.levels.ERROR)
              return nil
            end
            
            local bin_dir = vim.fn.getcwd() .. '/zig-out/bin'
            local files = vim.fn.glob(bin_dir .. '/*', false, true)
            if #files == 0 then
              vim.notify("❌ No executable found after build", vim.log.levels.ERROR)
              return nil
            end
            
            -- If only one executable, use it; otherwise let user choose
            if #files == 1 then
              return files[1]
            else
              return vim.fn.input('Path to executable: ', bin_dir .. '/', 'file')
            end
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = {},
          runInTerminal = false,
          sourceLanguages = { "zig" },
        }
      }

      -- JavaScript/TypeScript
      dap.configurations.javascript = {
        {
          name = "Launch Node.js",
          type = "node2",
          request = "launch",
          program = "${file}",
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
          protocol = "inspector",
          console = "integratedTerminal",
        },
        {
          name = "Attach to Node.js",
          type = "node2",
          request = "attach",
          processId = require'dap.utils'.pick_process,
        },
        {
          name = "Debug Jest Tests",
          type = "node2",
          request = "launch",
          cwd = vim.fn.getcwd(),
          runtimeArgs = {"--inspect-brk", "${workspaceFolder}/node_modules/.bin/jest", "--no-coverage", "-t", "${input:testNamePattern}"},
          sourceMaps = true,
          protocol = "inspector",
          skipFiles = {"<node_internals>/**/*.js"},
          console = "integratedTerminal",
          port = 9229,
        },
      }
      dap.configurations.typescript = dap.configurations.javascript

      -- Python configuration (will be enhanced by nvim-dap-python)
      dap.configurations.python = {
        {
          type = 'python',
          request = 'launch',
          name = "Launch file",
          program = "${file}",
          pythonPath = function()
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
              return cwd .. '/venv/bin/python'
            elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
              return cwd .. '/.venv/bin/python'
            else
              return '/usr/bin/python'
            end
          end,
        },
      }

      -- Load telescope extension
      pcall(function()
        require('telescope').load_extension('dap')
      end)

      -- Store DAP utilities in TacoVim namespace
      TacoVim.Debug = {
        -- Toggle breakpoint with optional condition
        toggle_breakpoint = function(condition)
          local ok, _ = pcall(function()
            if condition then
              dap.set_breakpoint(condition)
            else
              dap.toggle_breakpoint()
            end
          end)
          if not ok then
            vim.notify("❌ Debug adapter not ready", vim.log.levels.WARN)
          end
        end,
        
        -- Clear all breakpoints
        clear_breakpoints = function()
          local ok, _ = pcall(function()
            dap.clear_breakpoints()
            vim.notify("🧹 All breakpoints cleared", vim.log.levels.INFO)
          end)
          if not ok then
            vim.notify("❌ Debug adapter not ready", vim.log.levels.WARN)
          end
        end,
        
        -- Get active session info
        get_session = function()
          local ok, session = pcall(function()
            return dap.session()
          end)
          return ok and session or nil
        end,
        
        -- Custom run configuration
        run_with_args = function()
          local ok, _ = pcall(function()
            local args = vim.fn.input('Arguments: ')
            local config = dap.configurations[vim.bo.filetype] and dap.configurations[vim.bo.filetype][1]
            if config then
              config.args = vim.split(args, " ")
              dap.run(config)
            else
              vim.notify("❌ No debug configuration found for " .. vim.bo.filetype, vim.log.levels.WARN)
            end
          end)
          if not ok then
            vim.notify("❌ Debug adapter not ready", vim.log.levels.WARN)
          end
        end,
      }
    end,
  },

  -- =============================================================================
  -- MASON DAP SETUP
  -- =============================================================================
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = "mason.nvim",
    cmd = { "DapInstall", "DapUninstall" },
    opts = {
      automatic_installation = true,
      handlers = {},
      ensure_installed = {
        -- Core debuggers
        "python",
        "codelldb",
        "js-debug-adapter", 
        "chrome-debug-adapter",
        "firefox-debug-adapter",
        "node-debug2-adapter",
        
        -- Additional debuggers
        "bash-debug-adapter",
        "delve", -- Go debugger
        "netcoredbg", -- .NET debugger
      },
    },
  },

  -- =============================================================================
  -- LANGUAGE SPECIFIC DAP EXTENSIONS
  -- =============================================================================

  -- Python debugging
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
      if vim.fn.has("win32") == 1 then
        path = "~/.local/share/nvim/mason/packages/debugpy/venv/Scripts/python.exe"
      end
      require("dap-python").setup(path)
      
      -- Python specific keymaps
      vim.keymap.set("n", "<leader>dPt", function() 
        require("dap-python").test_method() 
      end, { desc = "🐍 Debug Python Test Method" })
      
      vim.keymap.set("n", "<leader>dPc", function() 
        require("dap-python").test_class() 
      end, { desc = "🐍 Debug Python Test Class" })
      
      vim.keymap.set("v", "<leader>dPs", function() 
        require("dap-python").debug_selection() 
      end, { desc = "🐍 Debug Python Selection" })
    end,
  },

  -- Go debugging
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      require("dap-go").setup({
        dap_configurations = {
          {
            type = "go",
            name = "Attach remote",
            mode = "remote",
            request = "attach",
          },
        },
        delve = {
          path = "dlv",
          initialize_timeout_sec = 20,
          port = "${port}",
          args = {},
          build_flags = "",
        },
      })
      
      -- Go specific keymaps
      vim.keymap.set("n", "<leader>dGt", function() 
        require("dap-go").debug_test() 
      end, { desc = "🐹 Debug Go Test" })
      
      vim.keymap.set("n", "<leader>dGl", function() 
        require("dap-go").debug_last_test() 
      end, { desc = "🐹 Debug Last Go Test" })
    end,
  },

  -- JavaScript/TypeScript debugging
  {
    "mxsdev/nvim-dap-vscode-js",
    ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      require("dap-vscode-js").setup({
        node_path = "node",
        debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter",
        adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
      })

      for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
        require("dap").configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require'dap.utils'.pick_process,
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-chrome",
            request = "launch",
            name = "Start Chrome with \"localhost\"",
            url = "http://localhost:3000",
            webRoot = "${workspaceFolder}",
          },
        }
      end
    end,
  },

  -- =============================================================================
  -- PERSISTENT BREAKPOINTS
  -- =============================================================================
  {
    "Weissle/persistent-breakpoints.nvim",
    lazy = true,
    keys = {
      { "<leader>dbt", function() require('persistent-breakpoints.api').toggle_breakpoint() end, desc = "🔴 Toggle Persistent Breakpoint" },
      { "<leader>dbc", function() require('persistent-breakpoints.api').clear_all_breakpoints() end, desc = "🧹 Clear Persistent Breakpoints" },
      { "<leader>dbs", function() require('persistent-breakpoints.api').set_conditional_breakpoint() end, desc = "🎯 Set Conditional Persistent Breakpoint" },
    },
    opts = {
      save_dir = vim.fn.stdpath('data') .. '/nvim_checkpoints',
      load_breakpoints_event = { "BufReadPost" },
      perf_record = false,
      perf_record_exe = "perf",
    }
  },

  -- =============================================================================
  -- DAP REPL IMPROVEMENTS
  -- =============================================================================
  {
    "LiadOz/nvim-dap-repl-highlights",
    dependencies = { 
      "mfussenegger/nvim-dap",
      "nvim-treesitter/nvim-treesitter",
    },
    event = "VeryLazy",
    config = function()
      pcall(function()
        -- The plugin handles parser installation automatically
        require("nvim-dap-repl-highlights").setup()
      end)
    end,
  },

  -- =============================================================================
  -- OVERSEER INTEGRATION FOR DEBUGGING
  -- =============================================================================
  {
    "stevearc/overseer.nvim",
    optional = true,
    dependencies = { "mfussenegger/nvim-dap" },
    opts = function(_, opts)
      local overseer = require("overseer")
      
      -- Add debug task template
      opts.task_list = opts.task_list or {}
      opts.templates = opts.templates or {}
      
      table.insert(opts.templates, "tacovim.debug_current_file")
      
      return opts
    end,
    config = function(_, opts)
      local overseer = require("overseer")
      overseer.setup(opts)
      
      -- Register debug task template
      overseer.register_template({
        name = "tacovim.debug_current_file",
        builder = function()
          local file = vim.fn.expand("%:p")
          local filetype = vim.bo.filetype
          
          return {
            name = "Debug " .. vim.fn.expand("%:t"),
            cmd = { "echo", "Starting debug session for", file },
            components = {
              "default",
              {
                "on_complete_callback",
                callback = function()
                  require("dap").continue()
                end,
              },
            },
          }
        end,
        condition = {
          filetype = { "rust", "go", "python", "javascript", "typescript", "c", "cpp", "zig" },
        },
      })
    end,
  },
}
