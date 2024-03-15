local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "4.0")
local theme = require("lua.theme.default")
local question = require("lua.question.main")
local font = theme.font.load()
local theme = theme.load()

local label = {}
label.theme_restore = {}

label.text = {
	welcome = "Welcome to AZLA",
	last_text = "You reached the last question",
	aze = "in Azerbajani ?",
	eng = "in English ?",
	lang = "Choose Language you want to write answers in:",
	wordlist = "Choose your wordlist",
	wordlist_count = "Choose word amount",
	restore_list = "Choose session to restore",
	remove_wordlist = "Choose wordlist to remove",
	remove_restore_list = "Choose session to remove",
}

function label.text.create_response(opt)
	local M = {}

	M.correctString = "Congratulations, your answer is Corrrect!!!"
	M.correctStringAlt = "Great Try!, \nyour answer is partially correct!, \nCorrect: " .. opt.correct
	M.correctLabel = "Question: " .. opt.word .. "\n " .. "Answer: " .. opt.choice .. "\n"
	M.incorrectString = "Sorry, your answer is incorrect.\nQuestion: "
	    .. opt.word
	    .. "\nCorrect answer: "
	    .. opt.correct
	M.incorrectLabel = "Question: "
	    .. opt.word
	    .. "\nCorrect: "
	    .. opt.correct
	    .. " "
	    .. "\nAnswer: "
	    .. opt.choice
	    .. "\n"

	return M
end

function label.end_create()
	local M = {}

	-- Make end Labels
	M.labelEnd = question.create_label({
		{
			attributes = "foreground='" .. theme.label_fg .. "'size='" .. font.fg_size .. "'",
			text = label.text.last_text,
		},
	})

	M.labelEnd:set_visible(false)
	-- Counts correct answers
	M.labelEndCorrect = Gtk.Label()
	-- Counts incorrect answers
	M.labelEndIncorrect = Gtk.Label()

	return M
end

function label.summary_create()
	label.summary = question.create_label({
		{
			attributes = "weight='bold' size='" ..
			font.welcome_size .. "' foreground='" .. theme.label_question .. "'",
			text = "Summary",
		},
	})

	label.summary:set_margin_bottom(30)
end

local restoreList = {
	setting = "setting",
	theme = "theme",
	font = "font",
}

for key, _ in pairs(restoreList) do
	label.theme_restore[key] = question.create_label({
		{
			attributes = "foreground='" .. theme.label_fg .. "'size='" .. font.fg_size .. "' ",
			text = "Restored to default settings",
		},
	})

	label.theme_restore[key]:set_visible(false)
	label.theme_restore[key]:set_margin_top(20)
end

label.language = Gtk.Label({ label = label.text.lang })

label.word_list = Gtk.Label({ label = label.text.wordlist, height_request = 50 })
label.word_count = Gtk.Label({ label = label.text.wordlist_count, height_request = 50 })
label.restore_list = Gtk.Label({ label = label.text.restore_list, height_request = 50, margin_top = 40 })
label.remove_wordlist = Gtk.Label({ label = label.text.remove_wordlist, height_request = 50, margin_top = 40 })
label.remove_restore_list = Gtk.Label({ label = label.text.remove_restore_list, height_request = 50, margin_top = 40 })

label.welcome = Gtk.Label({
	label = label.text.welcome,
	width_request = 200,
	height_request = 100,
	wrap = true,
})

label.theme = Gtk.Label({ label = "Settings", margin_top = 0 })

label.setting = Gtk.Label({ label = "Standard Settings", margin_top = 0 })

label.theme_color = Gtk.Label({ label = "Colors", margin_bottom = 10 })

label.theme_apply =
    Gtk.Label({ label = "Applied new settings. Please restart the app", margin_top = 40, visible = false })

label.theme_nochange = Gtk.Label({ label = "No change made", margin_top = 40, visible = false })

label.current_color_scheme = Gtk.Label({ margin_start = 50 })
label.current_color_scheme:set_margin_bottom(120)

label.welcome:set_markup(
	"<span size='"
	.. font.welcome_size
	.. "' foreground='"
	.. theme.label_welcome
	.. "'>"
	.. label.welcome.label
	.. "</span>"
)
label.word_list:set_markup(
	"<span size='"
	.. font.word_size
	.. "' foreground='"
	.. theme.label_word
	.. "'>"
	.. label.word_list.label
	.. "</span>"
)
label.word_count:set_markup(
	"<span size='"
	.. font.word_size
	.. "' foreground='"
	.. theme.label_word
	.. "'>"
	.. label.word_count.label
	.. "</span>"
)
label.restore_list:set_markup(
	"<span size='"
	.. font.word_size
	.. "' foreground='"
	.. theme.label_word
	.. "'>"
	.. label.restore_list.label
	.. "</span>"
)

label.remove_wordlist:set_markup(
	"<span size='"
	.. font.welcome_size
	.. "' foreground='"
	.. theme.label_word
	.. "'>"
	.. label.remove_wordlist.label
	.. "</span>"
)
label.remove_restore_list:set_markup(
	"<span size='"
	.. font.welcome_size
	.. "' foreground='"
	.. theme.label_word
	.. "'>"
	.. label.remove_restore_list.label
	.. "</span>"
)
label.language:set_markup(
	"<span size='"
	.. font.lang_size
	.. "' foreground='"
	.. theme.label_lang
	.. "'>"
	.. label.language.label
	.. "</span>"
)
label.theme:set_markup(
	"<span size='" ..
	font.welcome_size .. "' foreground='" .. theme.label_fg .. "'>" .. label.theme.label .. "</span>"
)
label.setting:set_markup(
	"<span size='"
	.. font.welcome_size
	.. "' foreground='"
	.. theme.label_fg
	.. "'>"
	.. label.setting.label
	.. "</span>"
)
label.theme_nochange:set_markup(
	"<span size='"
	.. font.welcome_size
	.. "' foreground='"
	.. theme.label_incorrect
	.. "'>"
	.. label.theme_nochange.label
	.. "</span>"
)
label.theme_apply:set_markup(
	"<span size='"
	.. font.fg_size
	.. "' foreground='"
	.. theme.label_correct
	.. "'>"
	.. label.theme_apply.label
	.. "</span>"
)

return label
