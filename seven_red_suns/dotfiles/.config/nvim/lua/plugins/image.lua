return {
	"3rd/image.nvim",
	build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
	opts = {
		processor = "magick_cli",
	},
	config = function(_, opts)
		-- 1. On gère l'état nous-mêmes dans une variable locale (plus d'erreur de structure !)
		local only_at_cursor = true

		-- 2. On crée une fonction qui applique la configuration à image.nvim
		local function apply_image_config()
			local final_opts = vim.tbl_deep_extend("force", opts or {}, {
				integrations = {
					markdown = {
						only_render_image_at_cursor = only_at_cursor,
						only_render_image_at_cursor_mode = "inline",
						-- CRUCIAL POUR VIMWIKI : On force le plugin à traiter
						-- le type 'vimwiki' avec la même logique que le markdown
						filetypes = { "markdown", "vimwiki" },
					},
				},
			})
			require("image").setup(final_opts)
		end

		-- Initialisation au démarrage de Neovim
		apply_image_config()

		-- 3. La fonction de bascule devient ultra-simple et robuste
		local function toggle_image_render_mode()
			-- Inversion de notre variable locale
			only_at_cursor = not only_at_cursor

			-- On réapplique la configuration fraîchement modifiée
			apply_image_config()

			-- On nettoie l'écran pour forcer le rafraîchissement des images
			require("image").clear()

			-- Notification visuelle
			if only_at_cursor then
				vim.notify("Image.nvim : Rendu au curseur uniquement", vim.log.levels.INFO)
			else
				vim.notify("Image.nvim : Rendu de toutes les images", vim.log.levels.INFO)
			end
		end

		vim.keymap.set("n", "<leader>si", toggle_image_render_mode, { desc = "Toggle Image Render Mode" })
	end,
}
