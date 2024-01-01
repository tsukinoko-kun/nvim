local map = require("utils").map

return {
	"mfussenegger/nvim-dap",
	config = function()
		-- keymaps
		map("n", "<f5>", "<cmd>DapContinue<cr>", {
			desc = "Continue",
		})
		map("n", "<f17>", "<cmd>DapTerminate<cr>", {
			desc = "Restart",
		})
		map("n", "<f10>", "<cmd>DapStepOver<cr>", {
			desc = "Step Over",
		})
		map("n", "<f11>", "<cmd>DapStepInto<cr>", {
			desc = "Step Into",
		})
		map("n", "<f23>", "<cmd>DapStepOut<cr>", {
			desc = "Step Out",
		})
		map("n", "<f9>", "<cmd>DapToggleBreakpoint<cr>", {
			desc = "Toggle Breakpoint",
		})
	end,
}
