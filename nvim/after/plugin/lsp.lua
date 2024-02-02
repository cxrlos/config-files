local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
	"tsserver",
	"rust_analyzer"
})

lsp.configure('lua-language-server', {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})

local cmp = require("cmp")
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
	["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
	["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
	["<C-y>"] = cmp.mapping.confirm({select = true}),
	["<C-Space>"] = cmp.mapping.complete()
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
	mapping = cmp_mappings,
})

lsp.on_attach(function(client, bufnr)
	local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

metals_config = require("metals").bare_config()
metals_config.init_options.statusBarProvider = "on"
metals_config.settings = { testUserInterface = "Test Explorer" }
local dap = require("dap")
dap.configurations.scala = {
  {
    type = "scala",
    request = "launch",
    name = "RunOrTest",
    metals = {
      runType = "runOrTestFile",
      --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
    },
  },
  {
    type = "scala",
    request = "launch",
    name = "Test Target",
    metals = {
      runType = "testTarget",
    },
  },
}

local handle_test_start = function(session, body)
  -- Clear the test result extmarks.
  -- this should be done on the actual buffer containing the test defintion, and only when starting tests, not
  -- when launching debugger, but I can't figure out how.
  local bufnr = vim.api.nvim_get_current_buf()
  local namespace = vim.api.nvim_create_namespace("dap-test-results")
  vim.diagnostic.reset(namespace, bufnr)
  vim.api.nvim_buf_clear_namespace(bufnr, namespace, 0, -1)
end

local handle_test_result = function(session, body)
  local namespace = vim.api.nvim_create_namespace("dap-test-results")
  local suite = nil
  local suite_bufnr = nil
  for _, project in pairs(metals_get_tests()) do
    for _, registered_suite in pairs(project.suites) do
      if registered_suite.fullyQualifiedClassName == body.data.suiteName then
        suite = registered_suite
        for _, buf in ipairs(vim.fn.getbufinfo()) do
          if suite.location.uri == "file://" .. buf.name then
            suite_bufnr = buf.bufnr
          end
        end
      end
    end
  end
  for _, test_result in ipairs(body.data.tests) do
    local test_linenr = nil
    for _, registered_test in pairs(suite.testCases) do
      if test_result.testName == registered_test.name then
        test_linenr = registered_test.location.range['end'].line
      end
    end
    if test_result.kind == "passed" then
      local text = {"✓", "DiagnosticOk"}
      vim.api.nvim_buf_set_extmark(suite_bufnr, namespace, test_linenr, 0, { virt_text = { text } })
    elseif test_result.kind == "skipped" then
      local text = {"skipped"}
      vim.api.nvim_buf_set_extmark(suite_bufnr, namespace, test_linenr, 0, { virt_text = { text } })
    elseif test_result.kind == "failed" then
      local text = {"⨯", "DiagnosticError"}
      vim.api.nvim_buf_set_extmark(suite_bufnr, namespace, test_linenr, 0, { virt_text = { text } })
      vim.diagnostic.set(
        namespace,
        suite_bufnr,
        {{
          lnum = test_linenr,
          col = 0,
          severity = vim.diagnostic.severity.ERROR,
          source = "dap-run-test",
          message = test_result.error,
          user_data = {},
        }}
      )
    end
  end
end

dap.listeners.after['event_testResult']['scalaTestResults'] = handle_test_result
dap.listeners.after['launch']['scalaTestResults'] = handle_test_start

metals_config.on_attach = function(client, bufnr)
  require("metals").setup_dap()
  dap.listeners.after['event_testResult']['scalaTestResults'] = handle_test_result
end

metals = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "scala", "sbt", "java" },
  callback = function()
    require("metals").initialize_or_attach(metals_config)
    require("metals").setup_dap()
  end,
  group = metals,
})

lsp.setup()
