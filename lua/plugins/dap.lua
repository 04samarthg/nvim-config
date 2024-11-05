return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",  -- For UI elements
      "theHamsta/nvim-dap-virtual-text", -- Inline virtual text
      "nvim-neotest/nvim-nio",
    },
    keys = { "<F5>", "<leader>db", "<leader>dr" },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      
      -- Configure GDB adapter
      dap.adapters.gdb = {
        type = "executable",
        command = "gdb",
        args = {"-i", "dap"}
      }
      
      -- Set up C++ configurations using GDB
      dap.configurations.cpp = {
        {
          name = "Launch file",
          type = "gdb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = true,
        },
      }
      
      -- Configure UI and virtual text
      dapui.setup()
      require("nvim-dap-virtual-text").setup()
      
      -- Auto-open and close DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
      
      -- Set breakpoint appearance
      vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "🟢", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" })
    end,
  },
}
