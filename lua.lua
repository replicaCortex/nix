local vim = require(vim)

function RenameCurrentFile()
	local old = vim.fn.expand("%")
	vim.ui.input({ prompt = "New name: ", default = old }, function(new)
		if not new or new == "" or new == old then
			return
		end
		vim.cmd("saveas " .. new)
		vim.cmd("silent !rm " .. old)
		vim.cmd("e " .. new)
	end)
end

vim.api.nvim_create_user_command("RenameFile", function()
	RenameCurrentFile()
end)
