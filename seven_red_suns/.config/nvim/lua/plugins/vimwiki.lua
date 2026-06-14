return {
	"vimwiki/vimwiki",
	init = function()
		vim.g.vimwiki_key_mappings = {
			headers = 0, -- Prevents Vimwiki from stealing '=' and '-'
		}
		vim.g.vimwiki_path = "~/vimwiki/"
		vim.g.vimwiki_syntax = "markdown"
		vim.g.vimwiki_ext = "md"
	end,
}
