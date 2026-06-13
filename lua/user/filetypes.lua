-- Filetype detection for WeChat Mini Program files
-- WXML files -> XML, WXSS files -> CSS

vim.filetype.add({
	extension = {
		wxml = "xml",
		wxss = "css",
	},
})
