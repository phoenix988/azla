local themeModule = require("lua.theme.default")
local font = themeModule.font.load()
local theme = themeModule.load()

-- Import functions needed
local list = require("lua.terminal.listFiles")
local replace = require("lua.question.replace")

-- Function that create all labels we need for azla
local response = {}

function response.labels(correct, choice, word)
	local label = require("lua.widgets.label")
    -- converts first letter of correct and choice tp uppercase
    local correctTemp = correct
	local correct = list.lower_case(correct, 2)
    local choiceTemp = choice
	local choice = list.lower_case(choice, 2)
    
    if correct == nil then
	    correct = list.to_upper(correctTemp)
    end
    
    if choice == nil then
	    choice = list.to_upper(choiceTemp)
    end

	local text = {}
	text.correct = correct
	text.choice = choice
	text.word = word

	-- Create the text to print for every answer
	text.response = label.text.create_response(text)

	response.correctString = text.response.correctString
	response.correctStringAlt = text.response.correctStringAlt
	response.correctLabel = text.response.correctLabel
	response.incorrectString = text.response.incorrectString
	response.incorrectLabel = text.response.incorrectLabel

	return response
end

-- Function to create the labels to print for every answer
function response.main(opt, labels, w, i, answer_result, choice, theme)
	local mode = require("lua.main").getWordList()

	if opt == "correct" then
		color = theme.label_correct
	elseif opt == "incorrect" then
		color = theme.label_incorrect
	end

	w.result_labels[i].label = labels
	w.result_labels[i]:set_markup("<span foreground='" .. color .. "'>" .. w.result_labels[i].label .. "</span>")
	w.result_labels[i]:set_markup("<span size='" .. font.fg_size .. "'>" .. w.result_labels[i].label .. "</span>")

	if mode.mode == false then
		w.submit_buttons[i]:set_visible(false)
		w.next_buttons[i]:set_visible(true)
	end

	if opt == "correct" then
		if question.label_correct == nil then
			question.label_correct = {}
		end
		question.label_correct[i] = answer_result
	elseif opt == "incorrect" then
		if question.label_incorrect == nil then
			question.label_incorrect = {}
		end
		question.label_incorrect[i] = answer_result
	end
end

return response
