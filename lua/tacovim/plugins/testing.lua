-- ~/.config/nvim/lua/tacovim/plugins/testing.lua
-- TacoVim Testing Framework Integration

return {
  -- =============================================================================
  -- NEOTEST - UNIVERSAL TEST RUNNER
  -- =============================================================================
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      
      -- Language adapters
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-go",
      "haydenmeade/neotest-jest",
      "marilari88/neotest-vitest",
      "rouge8/neotest-rust",
      "rcasia/neotest-java",
      "Issafalcon/neotest-dotnet",
      "MarkEmmons/neotest-deno",
      "nvim-neotest/neotest-plenary",
      "olimorris/neotest-phpunit",
      "stevanmilic/neotest-scala",
    },
    keys = {
      { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File" },
      { "<leader>tT", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Run All Test Files" },
      { "<leader>tr", function() require("neotest").run.run() end, desc = "Run Nearest" },
      { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Run Last" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary" },
      { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output" },
      { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel" },
      { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop" },
      { "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Toggle Watch" },
      { "<leader>td", function() require("neotest").run.run({strategy = "dap"}) end, desc = "Debug Nearest" },
      { "<leader>tD", function() require("neotest").run.run({vim.fn.expand("%"), strategy = "dap"}) end, desc = "Debug File" },
    },
    opts = {
      adapters = {
        "neotest-python",
        "neotest-go",
        "neotest-jest",
        "neotest-vitest",
        "neotest-rust",
        "neotest-java",
        "neotest-dotnet",
        "neotest-deno",
        "neotest-plenary",
        "neotest-phpunit",
        "neotest-scala",
      },
      status = { virtual_text = true },
      output = { open_on_run = true },
      quickfix = {
        open = function()
          if require("trouble").is_open() then
            require("trouble").open({ mode = "quickfix" })
          else
            vim.cmd("copen")
          end
        end,
      },
    },
    config = function(_, opts)
      local neotest_ns = vim.api.nvim_create_namespace("neotest")
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message = diagnostic.message
              :gsub("\n", " ")
              :gsub("\t", " ")
              :gsub("%s+", " ")
              :gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)

      if pcall(require, "trouble") then
        opts.consumers = opts.consumers or {}
        opts.consumers.trouble = function(client)
          client.listeners.results = function(adapter_id, results, partial)
            if partial then
              return
            end
            local tree = assert(client:get_position(nil, { adapter = adapter_id }))

            local failed = 0
            for pos_id, result in pairs(results) do
              if result.status == "failed" and tree:get_key(pos_id) then
                failed = failed + 1
              end
            end
            vim.schedule(function()
              local trouble = require("trouble")
              if trouble.is_open() then
                trouble.refresh()
                if failed == 0 then
                  trouble.close()
                end
              end
            end)
          end
          return {}
        end
      end

      if opts.adapters then
        local adapters = {}
        for name, config in pairs(opts.adapters or {}) do
          if type(name) == "number" then
            if type(config) == "string" then
              config = require(config)
            end
            adapters[#adapters + 1] = config
          elseif config ~= false then
            local adapter = require(name)
            if type(config) == "table" and not vim.tbl_isempty(config) then
              local meta = getmetatable(adapter)
              if adapter.setup then
                adapter.setup(config)
              elseif meta and meta.__call then
                adapter = adapter(config)
              else
                error("Adapter " .. name .. " does not support setup")
              end
            end
            adapters[#adapters + 1] = adapter
          end
        end
        opts.adapters = adapters
      end

      require("neotest").setup(opts)
    end,
  },

  -- =============================================================================
  -- LANGUAGE SPECIFIC TEST CONFIGURATIONS
  -- =============================================================================

  -- Python Testing
  {
    "nvim-neotest/neotest-python",
    dependencies = { "nvim-neotest/neotest" },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
            args = { "--log-level", "DEBUG" },
            runner = "pytest",
            python = function()
              local venv_path = vim.fn.getenv("VIRTUAL_ENV")
              if venv_path then
                return venv_path .. "/bin/python"
              end
              return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
            end,
            pytest_discover_instances = true,
          }),
        },
      })
    end,
  },

  -- Go Testing
  {
    "nvim-neotest/neotest-go",
    dependencies = { "nvim-neotest/neotest" },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-go")({
            experimental = {
              test_table = true,
            },
            args = { "-count=1", "-timeout=60s" }
          }),
        },
      })
    end,
  },

  -- JavaScript/TypeScript Testing
  {
    "haydenmeade/neotest-jest",
    dependencies = { "nvim-neotest/neotest" },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-jest")({
            jestCommand = "npm test --",
            jestConfigFile = "jest.config.js",
            env = { CI = true },
            cwd = function(path)
              return vim.fn.getcwd()
            end,
          }),
        },
      })
    end,
  },

  -- Vitest Testing
  {
    "marilari88/neotest-vitest",
    dependencies = { "nvim-neotest/neotest" },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-vitest")({
            filter_dir = function(name, rel_path, root)
              return name ~= "node_modules"
            end,
          }),
        },
      })
    end,
  },

  -- Rust Testing
  {
    "rouge8/neotest-rust",
    dependencies = { "nvim-neotest/neotest" },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-rust")({
            args = { "--no-capture" },
            dap_adapter = "codelldb",
          }),
        },
      })
    end,
  },

  -- =============================================================================
  -- VIM-TEST INTEGRATION
  -- =============================================================================
  {
    "vim-test/vim-test",
    keys = {
      { "<leader>tc", "<cmd>TestClass<cr>", desc = "Test Class" },
      { "<leader>tf", "<cmd>TestFile<cr>", desc = "Test File" },
      { "<leader>tl", "<cmd>TestLast<cr>", desc = "Test Last" },
      { "<leader>tn", "<cmd>TestNearest<cr>", desc = "Test Nearest" },
      { "<leader>ts", "<cmd>TestSuite<cr>", desc = "Test Suite" },
      { "<leader>tv", "<cmd>TestVisit<cr>", desc = "Test Visit" },
    },
    config = function()
      vim.g["test#strategy"] = "neovim"
      vim.g["test#neovim#term_position"] = "belowright"
      vim.g["test#neovim#preserve_screen"] = 1

      -- Language specific configurations
      vim.g["test#python#pytest#options"] = "-v"
      vim.g["test#javascript#jest#options"] = "--verbose"
      vim.g["test#go#gotest#options"] = "-v"
      vim.g["test#rust#cargotest#options"] = "-- --nocapture"
      
      -- Custom test runners
      vim.g["test#custom_runners"] = {
        rust = { "cargo-nextest" },
        python = { "pytest", "django" },
        javascript = { "jest", "vitest" },
        typescript = { "jest", "vitest" },
      }
    end,
  },

  -- =============================================================================
  -- COVERAGE INTEGRATION
  -- =============================================================================
  {
    "andythigpen/nvim-coverage",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>tcc", function() require("coverage").load(true) end, desc = "Load Coverage" },
      { "<leader>tcs", function() require("coverage").summary() end, desc = "Coverage Summary" },
      { "<leader>tct", function() require("coverage").toggle() end, desc = "Toggle Coverage" },
    },
    opts = {
      commands = true,
      highlights = {
        covered = { fg = "#C3E88D" },
        uncovered = { fg = "#F07178" },
      },
      signs = {
        covered = { hl = "CoverageCovered", text = "▎" },
        uncovered = { hl = "CoverageUncovered", text = "▎" },
      },
      summary = {
        min_coverage = 80.0,
      },
      lang = {
        python = {
          coverage_command = "coverage json --fail-under=0 -q -o -",
        },
        javascript = {
          coverage_file = "coverage/lcov.info",
        },
        go = {
          coverage_file = "coverage.out",
        },
        rust = {
          project_files_only = true,
          project_files = { "src/*", "tests/*" },
        },
      },
    },
  },

  -- =============================================================================
  -- TESTING UTILITIES
  -- =============================================================================
  {
    "David-Kunz/jester",
    ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
    keys = {
      { "<leader>tjr", function() require("jester").run() end, desc = "Jest Run" },
      { "<leader>tjf", function() require("jester").run_file() end, desc = "Jest Run File" },
      { "<leader>tjl", function() require("jester").run_last() end, desc = "Jest Run Last" },
      { "<leader>tjd", function() require("jester").debug() end, desc = "Jest Debug" },
      { "<leader>tjD", function() require("jester").debug_file() end, desc = "Jest Debug File" },
    },
    opts = {
      cmd = "npm test -- --no-coverage -t '$result'",
      identifiers = {"test", "it"},
      prepend = {"describe"},
      expressions = {"call_expression"},
      path_to_jest_run = "npm test --",
      path_to_jest_debug = "node --inspect-brk ./node_modules/.bin/jest --no-coverage --runInBand",
      terminal_cmd = ":vsplit | terminal",
      dap = {
        console = "integratedTerminal",
        type = "pwa-node",
        request = "launch",
        cwd = vim.fn.getcwd(),
        runtimeArgs = {"--inspect-brk", "${workspaceFolder}/node_modules/.bin/jest", "--no-coverage", "-t", "$result", "--runInBand"},
        args = { "--no-coverage", "-t", "$result", "--runInBand" },
        sourceMaps = true,
        protocol = "inspector",
        skipFiles = {"<node_internals>/**/*.js"},
        console = "integratedTerminal",
        port = 9229,
        disableOptimisticBPs = true,
      },
    },
  },

  -- =============================================================================
  -- PLAYWRIGHT TESTING
  -- =============================================================================
  {
    "thenbe/neotest-playwright",
    dependencies = { "nvim-neotest/neotest" },
    ft = { "javascript", "typescript" },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-playwright").adapter({
            options = {
              persist_project_selection = true,
              enable_dynamic_test_discovery = true,
            }
          }),
        },
      })
    end,
  },

  -- =============================================================================
  -- SNAPSHOT TESTING
  -- =============================================================================
  {
    "gootorov/e2e.nvim",
    ft = { "javascript", "typescript" },
    keys = {
      { "<leader>tee", function() require("e2e").run() end, desc = "E2E Run" },
      { "<leader>ted", function() require("e2e").debug() end, desc = "E2E Debug" },
      { "<leader>tes", function() require("e2e").stop() end, desc = "E2E Stop" },
    },
    opts = {
      setup_commands = {
        npm = "npm run test:e2e",
        yarn = "yarn test:e2e",
        pnpm = "pnpm test:e2e",
      },
    },
  },

  -- =============================================================================
  -- TESTING DASHBOARD
  -- =============================================================================
  {
    "nvim-neotest/neotest",
    optional = true,
    opts = function(_, opts)
      table.insert(opts.adapters, {
        require("neotest-python")({
          dap = { justMyCode = false },
          args = {"--log-level", "DEBUG"},
          runner = "pytest",
        })
      })
      return opts
    end,
  },

  -- =============================================================================
  -- ULTEST (LEGACY SUPPORT)
  -- =============================================================================
  {
    "rcarriga/vim-ultest",
    dependencies = {"vim-test/vim-test"},
    build = ":UpdateRemotePlugins",
    keys = {
      { "<leader>tU", "<cmd>Ultest<cr>", desc = "Ultest" },
      { "<leader>tu", "<cmd>UltestNearest<cr>", desc = "Ultest Nearest" },
      { "<leader>tF", "<cmd>UltestSummary<cr>", desc = "Ultest Summary" },
    },
    config = function()
      vim.g.ultest_use_pty = 1
      vim.g.ultest_output_on_line = 0
      vim.g.ultest_output_on_run = 0
      vim.g.ultest_max_threads = 4
      vim.g.ultest_virtual_text = 1
    end,
  },

  -- =============================================================================
  -- TESTING ENHANCEMENTS
  -- =============================================================================
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { 
          "python", "go", "javascript", "typescript", "rust", "java", "c_sharp"
        })
      end
    end,
  },

  -- Test result annotations
  {
    "yamatsum/nvim-cursorline",
    event = "VeryLazy",
    opts = {
      cursorline = {
        enable = true,
        timeout = 1000,
        number = false,
      },
      cursorword = {
        enable = true,
        min_length = 3,
        hl = { underline = true },
      }
    },
  },

  -- =============================================================================
  -- BENCHMARKING
  -- =============================================================================
  {
    "p00f/cphelper.nvim",
    ft = { "cpp", "c" },
    keys = {
      { "<leader>tcr", function() require("cphelper").run() end, desc = "Competitive Programming Run" },
      { "<leader>tct", function() require("cphelper").test() end, desc = "Competitive Programming Test" },
      { "<leader>tcd", function() require("cphelper").debug() end, desc = "Competitive Programming Debug" },
    },
    opts = {
      lang = "cpp",
      template_path = vim.fn.stdpath("config") .. "/templates/competitive_programming_template.cpp",
    },
  },

  -- Store testing utilities in TacoVim namespace
  {
    "nvim-lua/plenary.nvim",
    config = function()
      TacoVim.Testing = {
        -- Run all tests in current file
        run_file_tests = function()
          if pcall(require, "neotest") then
            require("neotest").run.run(vim.fn.expand("%"))
          else
            vim.cmd("TestFile")
          end
        end,
        
        -- Run nearest test
        run_nearest_test = function()
          if pcall(require, "neotest") then
            require("neotest").run.run()
          else
            vim.cmd("TestNearest")
          end
        end,
        
        -- Debug nearest test
        debug_nearest_test = function()
          if pcall(require, "neotest") then
            require("neotest").run.run({strategy = "dap"})
          else
            vim.notify("Debug testing requires neotest", vim.log.levels.WARN)
          end
        end,
        
        -- Toggle test summary
        toggle_summary = function()
          if pcall(require, "neotest") then
            require("neotest").summary.toggle()
          else
            vim.cmd("UltestSummary")
          end
        end,
        
        -- Watch tests
        toggle_watch = function()
          if pcall(require, "neotest") then
            require("neotest").watch.toggle(vim.fn.expand("%"))
          else
            vim.notify("Test watching requires neotest", vim.log.levels.WARN)
          end
        end,
        
        -- Get test status
        get_status = function()
          if pcall(require, "neotest") then
            return require("neotest").state.status()
          end
          return nil
        end,
      }
    end,
  },
}
