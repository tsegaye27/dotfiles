if not pcall(require, "jdtls") then
	return
end

local jdtls = require("jdtls")
local mason_path = vim.fn.stdpath("data") .. "/mason"
local launcher = vim.fn.glob(mason_path .. "/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar")

-- CHANGE 1: dynamic OS detection instead of hardcoded config_mac_arm
local os_name = vim.loop.os_uname().sysname
local config_dir
if os_name == "Darwin" then
	-- detect arm vs x86
	local arch = vim.fn.system("uname -m"):gsub("\n", "")
	if arch == "arm64" then
		config_dir = mason_path .. "/packages/jdtls/config_mac_arm"
	else
		config_dir = mason_path .. "/packages/jdtls/config_mac"
	end
elseif os_name == "Linux" then
	config_dir = mason_path .. "/packages/jdtls/config_linux"
else
	config_dir = mason_path .. "/packages/jdtls/config_win"
end

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

-- CHANGE 2: collect debug/test bundles
local bundles = {}
local debug_jar =
	vim.fn.glob(mason_path .. "/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar")
if debug_jar ~= "" then
	table.insert(bundles, debug_jar)
end
vim.list_extend(
	bundles,
	vim.split(vim.fn.glob(mason_path .. "/packages/java-test/extension/server/*.jar"), "\n", { trimempty = true })
)

-- CHANGE 3: lombok path (download lombok.jar and place it here manually once)
local lombok_jar = mason_path .. "/packages/jdtls/lombok.jar"
local lombok_arg = ""
if vim.fn.filereadable(lombok_jar) == 1 then
	lombok_arg = "-javaagent:" .. lombok_jar
end

local cmd = {
	"java",
}

-- lombok must come right after "java", before other JVM args
if lombok_arg ~= "" then
	table.insert(cmd, lombok_arg)
end

vim.list_extend(cmd, {
	"-Declipse.application=org.eclipse.jdt.ls.core.id1",
	"-Dosgi.bundles.defaultStartLevel=4",
	"-Declipse.product=org.eclipse.jdt.ls.core.product",
	"-Dlog.level=ALL",
	"-Xmx4g",
	"--add-modules=ALL-SYSTEM",
	"--add-opens",
	"java.base/java.util=ALL-UNNAMED",
	"--add-opens",
	"java.base/java.lang=ALL-UNNAMED",
	"-jar",
	launcher,
	"-configuration",
	config_dir,
	"-data",
	workspace_dir,
})

local config = {
	cmd = cmd,
	root_dir = require("jdtls.setup").find_root({ "pom.xml", "build.gradle", ".git" }),
	capabilities = capabilities,

	settings = {
		java = {
			eclipse = { downloadSources = true },
			configuration = { updateBuildConfiguration = "interactive" },
			maven = { downloadSources = true },
			implementationsCodeLens = { enabled = true },
			referencesCodeLens = { enabled = true },
			inlayHints = { parameterNames = { enabled = "all" } },
			-- CHANGE 4: use google style or keep default; explicit tabSize for Java
			format = {
				enabled = true,
				settings = {
					tabSize = 4,
					insertSpaces = false, -- use real tabs, Java convention; flip to true if you prefer spaces
				},
			},
			signatureHelp = { enabled = true },
			contentProvider = { preferred = "fernflower" }, -- CHANGE 5: better decompiler
			completion = {
				favoriteStaticMembers = {
					"org.junit.Assert.*",
					"org.junit.jupiter.api.Assertions.*",
					"org.mockito.Mockito.*",
					"org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*",
					"org.springframework.test.web.servlet.result.MockMvcResultMatchers.*",
				},
				filteredTypes = { -- CHANGE 6: filter noise from completions
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
		},
	},

	-- CHANGE 7: extendedClientCapabilities so Spring tooling and refactors work
	init_options = {
		bundles = bundles,
		extendedClientCapabilities = jdtls.extendedClientCapabilities,
	},

	on_attach = function(client, bufnr)
		-- CHANGE 8: wire up DAP properly
		jdtls.setup_dap({ hotcodereplace = "auto" })
		require("jdtls.dap").setup_dap_main_class_configs()

		local map = function(keys, fn, desc)
			vim.keymap.set("n", keys, fn, { buffer = bufnr, desc = "Java: " .. desc })
		end

		-- standard LSP
		map("gd", vim.lsp.buf.definition, "Go to Definition")
		map("gr", vim.lsp.buf.references, "References")
		map("K", vim.lsp.buf.hover, "Hover docs")
		map("<leader>rn", vim.lsp.buf.rename, "Rename")
		map("<leader>ca", vim.lsp.buf.code_action, "Code action")
		map("[d", vim.diagnostic.goto_prev, "Prev diagnostic")
		map("]d", vim.diagnostic.goto_next, "Next diagnostic")
		map("<leader>df", vim.diagnostic.open_float, "Float diagnostic")

		-- jdtls refactors
		map("<leader>jo", jdtls.organize_imports, "Organize imports")
		map("<leader>jv", jdtls.extract_variable, "Extract variable")
		map("<leader>jm", jdtls.extract_method, "Extract method")
		map("<leader>jc", jdtls.extract_constant, "Extract constant")
		map("<leader>ju", "<cmd>JdtUpdateConfig<CR>", "Update config")

		-- DAP / test
		map("<leader>jt", require("jdtls.dap").test_nearest_method, "Test nearest method")
		map("<leader>jT", require("jdtls.dap").test_class, "Test class")

		-- CHANGE 9: attach to running Spring Boot process on port 5005
		map("<leader>jD", function()
			local dap = require("dap")
			dap.configurations.java = dap.configurations.java or {}
			-- only add once
			local already = false
			for _, c in ipairs(dap.configurations.java) do
				if c.name == "Attach Spring Boot :5005" then
					already = true
					break
				end
			end
			if not already then
				table.insert(dap.configurations.java, {
					type = "java",
					request = "attach",
					name = "Attach Spring Boot :5005",
					hostName = "localhost",
					port = 5005,
				})
			end
			dap.continue()
		end, "Attach debugger to Spring Boot :5005")
	end,
}

jdtls.start_or_attach(config)
