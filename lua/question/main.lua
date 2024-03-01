---@diagnostic disable: need-check-nil
--{{Function to run the questions for my Azla GTK app

-- Imports libaries we need
local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "4.0")
local GObject = lgi.require("GObject", "2.0")
local GdkPixbuf = lgi.require("GdkPixbuf")
local lfs = require("lfs")
local os = require("os")
local theme = require("lua.theme.default")
local replace = require("lua.question.replace")
local response = require("lua.question.response")
local list = require("lua.terminal.listFiles")
local style = require("lua.widgets.setting")
local wordview = require("lua.widgets.button.questionView")
local json = require("lua.question.save")

local count = 0

question = {}

-- Counts correct answer to export
question.correct = 0
question.incorrect = 0
question.current = 0

-- keep track of questions
local currentQuestion = 1


local previous = nil
local previousModel = nil
local previousIter = nil

-- check so you dont add unlimited checkmarks to the treeview
local checkForMultiple = {}

-- Function to create a label with multiple span sections
function question.create_label(spans)
	local label = Gtk.Label()
	local markup = ""

	for i, span in ipairs(spans) do
		markup = markup .. string.format("<span %s>%s</span>", span.attributes, span.text)
	end

	label:set_markup(markup)

	return label
end

-- Update the treeview for the wordlist on the left side
function question.update_tree(treeTable, w)
	for key, value in pairs(treeTable) do
		local check = w.entry_fields[key].text:lower()
		local check = string.gsub(check, "%s", "")
		if check ~= nil and check ~= "" and string.match(check, "%S") then
			local value = mainWordList[key][languageNumber_2] .. " ✓ "
			local value = list.to_upper(value)
			mainWordList[key][languageNumber_2] = value
			wordview.listStore:append({ key .. " " .. value })
		else
			local value = mainWordList[key][languageNumber_2]
			local value = list.to_upper(value)
			wordview.listStore:append({ key .. " " .. value })
		end
	end
end

-- Runs the function
function question.main(wordlist, w, mainGrid, questionGrid, currentQuestion, bt)
	-- Import labels
	local label = require("lua.widgets.label")

	question.jsonSettings = {}
	question.jsonSettings.word = {}
	question.jsonSettings.entry = {}
	question.session_count = 1

	-- Load the theme and font to use
	local theme = require("lua.theme.default")
	local font = theme.font.load()
	local theme = theme.load()

	-- Gets the current mode of Azla
	local mode = require("lua.main").getWordList()
	question.mode = require("lua.question.examMode")

	-- Making empty widgets
	w.question_labels = {}
	w.submit_buttons = {}
	w.current_labels = {}
	w.next_buttons = {}
	w.entry_fields = {}
	w.result_labels = {}
	w.show_result_labels = {}

	local prevButton = Gtk.Button({ label = "Prev" })
	local submitButton = Gtk.Button({ label = "Submit" })
	local nextButton = Gtk.Button({ label = "Next" })

	local prevButton = style.set_theme(prevButton, {
		{ size = font.fg_size / 1000, color = theme.label_question, border_color = theme.label_fg },
	})

	local submitButton = style.set_theme(submitButton, {
		{ size = font.fg_size / 1000, color = theme.label_question, border_color = theme.label_fg },
	})

	local nextButton = style.set_theme(nextButton, {
		{ size = font.fg_size / 1000, color = theme.label_question, border_color = theme.label_fg },
	})

	-- Imports wordlist choice
	local mainWindowModule = require("lua.main").getWordList

	-- Gets the word count choice
	local wordlistCount = getWordList()

	-- Import switchquestion function
	local import = require("lua.switchQuestion")
	local switchQuestion = import.switchQuestion

	-- Imports the variable needed to determine which language you choose
	local mainWindowModule = require("lua.main")
	local getLanguageChoice = mainWindowModule.getLanguageChoice
	local languageChoice = getLanguageChoice()

	-- Relaunches the wordlist language if you restore session
	if wordlist.lang then
		if wordlist.lang == "azerbajani" then
			languageNumber_1 = 1
			languageNumber_2 = 2
			languageString = label.text.aze
			question.jsonSettings.lang = "azerbajani"
		elseif wordlist.lang == "english" then
			languageNumber_1 = 2
			languageNumber_2 = 1
			languageString = label.text.eng
			question.jsonSettings.lang = "english"
		end

	-- Sets the variables depending on choice
	elseif languageChoice == "azerbajani" then
		languageNumber_1 = 1
		languageNumber_2 = 2
		languageString = label.text.aze
		question.jsonSettings.lang = "azerbajani"
	elseif languageChoice == "english" then
		languageNumber_1 = 2
		languageNumber_2 = 1
		languageString = label.text.eng
		question.jsonSettings.lang = "english"
	end

	-- Gets the wordlist count value of the combo count box
	local count = tonumber(wordlist.count)

	local wordTable = {}

	question.jsonSettings.wordlist = wordlist.name
	question.jsonSettings.count_last = count

	currentQuestion = import.loadLast(wordlist)
	question.count_start = wordlist.count_start

	if wordlist.words then
		local numTable = {}
		local entryTable = {}
		newWordList = {}

		local function customSort(a, b)
			local numA, strA = tonumber(a[1]:match("(%d+)_.*")), a[1]
			local numB, strB = tonumber(b[1]:match("(%d+)_.*")), b[1]

			return numA < numB
		end

		for key, value in pairs(wordlist.words) do
			--local key = string.match(key, "([^_]+)")
			--local result = string.match(variable, "_(.*)")
			table.insert(numTable, { key, value })
		end

		table.sort(numTable, customSort)

		for i, value in ipairs(numTable) do
			local new = string.match(value[1], "_(.*)")
			table.insert(newWordList, { value[2], new })
		end

		if wordlist.correct then
			question.correct = wordlist.correct
		end

		if wordlist.incorrect then
			question.incorrect = wordlist.incorrect
		end
	end

	-- Create the main wordlist to loop through
	if newWordList then
		mainWordList = newWordList
		newWordList = nil
	else
		mainWordList = wordlist
	end

	-- Create a table to list the words in a tree
	for i = 1, math.min(#mainWordList, count) do
		local word = mainWordList[i][languageNumber_2]
		local word = list.to_upper(word)

		local append = i .. " " .. word
		table.insert(wordTable, append)
	end

	-- create treeView widget
	local treeView = wordview:create_tree(wordTable)
	wg.treeWidget = treeView

	-- Adss the questionGrid to the wg table
	wg.tree = questionGrid

	-- Iterate over the wordlist using a for loop
	-- for i = 1, #wordlist do
	for i = 1, math.min(#mainWordList, count) do
		-- Counts current question
		question.current = question.current + 1
		question.last = i

		-- Gets the correct answer and stores it in a variable
		local correct = string.lower(mainWordList[i][languageNumber_1])
		local word = mainWordList[i][languageNumber_2]
		local word = list.to_upper(word)
		-- Make a json setting table and write all the words to it
		-- If you choose english option
		if wordlist.lang == "english" then
			if question.session_count == 1 then
				question.jsonSettings.word[tostring(i) .. "_" .. mainWordList[i][2]] = mainWordList[i][1]
				question.session_count = question.session_count + 1
			elseif question.session_count == 2 then
				question.jsonSettings.word[tostring(i) .. "_" .. mainWordList[i][2]] = mainWordList[i][1]
				question.session_count = 1
			end
		-- If you choose azerbajani option
		elseif wordlist.lang == "azerbajani" then
			mainWordList[i][1] = mainWordList[i][2]
			if question.session_count == 1 then
				mainWordList[i][2], mainWordList[i][1] = mainWordList[i][1], mainWordList[i][2]
				question.jsonSettings.word[tostring(i) .. "_" .. mainWordList[i][2]] = mainWordList[i][1]
				question.session_count = question.session_count + 1
			elseif question.session_count == 2 then
				mainWordList[i][1], mainWordList[i][2] = mainWordList[i][2], mainWordList[i][1]
				question.jsonSettings.word[tostring(i) .. "_" .. mainWordList[i][2]] = mainWordList[i][1]
				question.session_count = 1
			end
		-- Make sure that it write to the json file correctly
		-- otherwise the restore button will restore the words in the wrong order
		else
			if languageChoice == "azerbajani" then
				question.jsonSettings.word[tostring(i) .. "_" .. word] = correct
			elseif languageChoice == "english" then
				question.jsonSettings.word[tostring(i) .. "_" .. correct] = word
			end
		end

		w.question_labels[i] = question.create_label({
			{
				attributes = "weight='bold' foreground='" .. theme.label_question .. "'",
				text = question.current,
			},
			{
				attributes = "weight='bold'",
				text = " What is ",
			},
			{
				attributes = "size='" .. font.question_size .. "' foreground='" .. theme.label_question .. "'",
				text = word,
			},
			{
				attributes = "weight='bold'",
				text = " " .. languageString,
			},
		})

		-- Create labels that displays current question
		w.current_labels[i] = Gtk.Label({ label = "Current: " .. question.current })
		w.current_labels[i]:set_markup(
			"<span size='"
				.. font.fg_size
				.. ""
				.. "' foreground='"
				.. theme.label_question
				.. "'>"
				.. w.current_labels[i].label
				.. "</span>"
		)

		-- sets size of question label
		w.question_labels[i]:set_markup(
			"<span size='"
				.. font.question_size
				.. ""
				.. "' foreground='"
				.. theme.label_fg
				.. "'>"
				.. w.question_labels[i].label
				.. "</span>"
		)

		-- Create entry field for each question
		w.entry_fields[i] = Gtk.Entry()

		w.entry_fields[i]:set_size_request(200, 50) -- Set width = 200, height = 100

		-- Set style of entry box
		w.entry_fields[i] = style.set_theme(w.entry_fields[i], {
			{ size = font.entry_size / 1000, color = theme.label_question, border_color = theme.label_fg },
		})

		-- Create submit button for each question
		w.submit_buttons[i] = Gtk.Button({
			label = "Submit",
		})

		-- Create next button for each question
		w.next_buttons[i] = Gtk.Button({ label = "Next" })
		w.next_buttons[i]:set_size_request(100, 10)

		-- Sets theme of next and submit buttons
		style.set_theme(w.next_buttons[i], {
			{ size = font.fg_size / 1000, color = theme.label_question, border_color = theme.label_fg },
		})
		style.set_theme(w.submit_buttons[i], {
			{ size = font.fg_size / 1000, color = theme.label_question, border_color = theme.label_fg },
		})

		-- Create next button action and in this case it will call switchQuestion
		w.next_buttons[i].on_clicked = function()
			w.question_labels[currentQuestion]:set_visible(false)

			-- Move to the next question
			currentQuestion = switchQuestion(true, question, w, wg, bt)

			-- Updates click function on back button
			-- Resets the session if you reach the last question
			function bt.last.back:on_clicked()
				currentQuestion = currentQuestion
				if tonumber(currentQuestion) > tonumber(wordlist.count) then
					question.jsonSettings = {}
					json.saveSession(question.jsonSettings)
				end
			end

			question.count_start = currentQuestion

			if mode.mode == true then
				if w.next_buttons[currentQuestion] ~= nil then
					w.next_buttons[currentQuestion]:set_visible(true)
				end
				if currentQuestion == question.last then
					w.next_buttons[currentQuestion]:set_visible(false)
					submitButton:set_visible(true)
				end
			end

			local model = treeView:get_model()
			-- Get the tree selection and set the default selection
			local selection = treeView:get_selection()
			local model = treeView:get_model()
			local iter = model:get_iter_from_string(tostring(currentQuestion - 1)) -- Select the first row
			if currentQuestion <= question.last then
				selection:select_iter(iter)
			end
		end

		-- Create result label for each question
		w.result_labels[i] = Gtk.Label({ visible = false })

		w.show_result_labels[i] = Gtk.Label({ visible = false })

		-- Create entry box text if you restore session
		if wordlist.words then
			for key, value in pairs(wordlist.entry) do
				local altCorrectRun = false
				if value == i then
					response.labels(correct, key, word)
					local correctString = response.correctString
					local correctStringAlt = response.correctStringAlt
					local correctLabel = response.correctLabel
					local incorrectString = response.incorrectString
					local incorrectLabel = response.incorrectLabel

					-- Alternative correct answer
					local altCorrect = replace.replace_main(correct)

					-- Remove leading spaces
					local key = string.gsub(key, "^%s*", "")

					-- Remove trailing spaces
					local key = string.gsub(key, "%s*$", "")
					if not mode.mode then
						if key == correct then
							opt = "correct"
							correct_answers = response.main(opt, correctString, w, i, correctLabel, choice, theme)
						else
							for _, value in pairs(altCorrect) do
								if value == key then
									opt = "correct"
									response.main(opt, correctStringAlt, w, i, correctLabel, choice, theme)
									altCorrectRun = true
								end
							end
						end

						if key ~= correct and not altCorrectRun then
							opt = "incorrect"
							incorrect_answers = response.main(opt, incorrectString, w, i, incorrectLabel, choice, theme)
						end
					end
					w.entry_fields[i]:set_text(key)
					question.jsonSettings.entry[key] = value

					if not mode.mode then
						w.entry_fields[i]:set_editable(false)
					end
					break
				end
			end
		end

        question.jsonSettings.entry = {}
		
        -- Define the callback function for the submit button
		w.submit_buttons[i].on_clicked = function()
			question.jsonSettings.count = i
			-- Catch your choice
			local choice = w.entry_fields[i].text:lower()

			-- Remove leading spaces
			local choice = string.gsub(choice, "^%s*", "")

			-- Remove trailing spaces
			local choice = string.gsub(choice, "%s*$", "")

			question.jsonSettings.entry[choice] = i

			-- Alternative correct answer
			local altCorrect = replace.replace_main(correct)

			-- sets dont run variable
			local dontRun = false

			-- create all the labels imported from respones.lua in this dir
			response.labels(correct, choice, word)
			local correctString = response.correctString
			local correctStringAlt = response.correctStringAlt
			local correctLabel = response.correctLabel
			local incorrectString = response.incorrectString
			local incorrectLabel = response.incorrectLabel

			-- Evaluates if answer is correct
			if choice == correct then
				-- runs the function
				question.correct = question.correct + 1
				local opt = "correct"
				correct_answers = response.main(opt, correctString, w, i, correctLabel, choice, theme)

				question.jsonSettings.correct = question.correct
			else
				for key, value in pairs(altCorrect) do
					if value == choice then
						-- runs the function
						local opt = "correct"
						response.main(opt, correctStringAlt, w, i, correctLabel, choice, theme)

						-- Wont run next statement if this runs
						dontRun = true
					end
				end
			end -- End of if Statement

			-- Runs if answer is incorrect
			if choice ~= correct and not dontRun then
				question.incorrect = question.incorrect + 1
				question.jsonSettings.incorrect = question.incorrect
				-- runs the function
				local opt = "incorrect"
				response.main(opt, incorrectString, w, i, incorrectLabel, choice, theme)
			elseif dontRun then
				question.correct = question.correct + 1
				question.jsonSettings.correct = question.correct
			end

			w.entry_fields[i]:set_editable(false)

			-- Create the treetable so I can dynamiclly update the treeview
			local treeTable = {}
			for i = 1, question.last do
				treeTable[i] = mainWordList[i][languageNumber_2]
				treeTable[i] = list.to_upper(treeTable[i])
			end
		end

		-- Sets default visibility of all widgets
		for widget, _ in pairs(w) do
			if i == 1 then
				w[widget][i]:set_visible(true)
			else
				w[widget][i]:set_visible(false)
			end
		end

		if i == 1 then
			w.next_buttons[i]:set_visible(false)
		end

		-- Appends them all to the main box
		mainGrid:attach(w.question_labels[i], 0, 0, 1, 1)
		mainGrid:attach(w.entry_fields[i], 0, 1, 1, 1)
		if mode.mode == false then
			mainGrid:attach(w.result_labels[i], 0, 2, 1, 1)
			mainGrid:attach(w.submit_buttons[i], 0, 3, 1, 1)
			mainGrid:attach(w.next_buttons[i], 0, 4, 1, 1)
		end
		mainGrid:attach(w.show_result_labels[i], 0, 5, 1, 1)

		count = count + 1
	end -- End for loop

	if mode.mode == true then
		mainGrid:attach(prevButton, 0, 5, 1, 1)
		mainGrid:attach(submitButton, 0, 4, 1, 1)
		mainGrid:attach(nextButton, 0, 4, 1, 1)
		submitButton:set_visible(false)
		question.jsonSettings.exam_mode = true
	else
		question.jsonSettings.exam_mode = false
	end

	questionGrid:attach(treeView, 0, 0, 1, 1)

	-- Create the treetable so I can dynamiclly update the treeview
	local treeTable = {}
	for i = 1, question.last do
		treeTable[i] = wordlist[i][languageNumber_2]
		treeTable[i] = list.to_upper(treeTable[i])
	end

	local selection = treeView:get_selection()

	-- Initialize variables to store previous tree selection
	local previous = nil
	local previousModel = nil
	local previousIter = nil
    local checkForMultiple = {}
	
    local treeFirst = true

	-- Clear wordview
	wordview.listStore:clear()

	-- Add checkmark if the question is answered from previous session
	question.update_tree(treeTable, w)

	-- action to run when you change the treeview
	selection.on_changed:connect(function()
		if previousModel and previousIter then
			local value = previousModel:get_value(previousIter, 0) -- Assuming the value is in column 0
			stringValue = value:get_string() -- Convert value to string
			for key, value in pairs(w.entry_fields) do
				local check = w.entry_fields[key].text:lower()
				local check = string.gsub(check, "%s", "")
				if checkForMultiple[key] == "1" then
                     local trash
				elseif check ~= nil and check ~= "" and string.match(check, "%S") then
					previousModel:set(previousIter, { stringValue .. " ✓ " })
                    check = nil
				    checkForMultiple[key] = "1" 
				end
			end
		end

		local currentPath, currentIter = selection:get_selected()

		local selection = treeView:get_selection()
		local model, iter = selection:get_selected()
		local selectedRows = selection.get_selected_rows

		if model and iter then
			local value = model:get_value(iter, 0) -- Assuming the value is in column 0
			stringValue = value:get_string() -- Convert value to string
		end

		-- Dont know what to these lines do
		local stringValue = string.match(stringValue, "(%d+)%s")
		local stringValue = tonumber(stringValue)
		question.count_start = stringValue

		-- Move to the next question
		currentQuestion = switchQuestion(stringValue, question, w, wg, bt)

		if mode.mode == false then
			w.next_buttons[stringValue]:set_visible(false)
		end

		if stringValue == question.last and mode.mode == true then
			submitButton:set_visible(true)
			nextButton:set_visible(false)
		else
			submitButton:set_visible(false)
			nextButton:set_visible(true)
		end

		treeFirst = false
        
        -- Updates previous value
		previous = stringValue
		previousModel, previousIter = model, iter

	end)

	-- Button to go back one question
	function prevButton:on_clicked()
		submitButton:set_visible(false)

		if currentQuestion == 1 then
			local pop = require("lua.question.popups")

			pop.first_question()
		end

		-- Move to the next question
		currentQuestion = switchQuestion(false, question, w, wg, bt)

		local model = treeView:get_model()
		-- Get the tree selection and set the default selection
		local selection = treeView:get_selection()
		local model = treeView:get_model()
		local iter = model:get_iter_from_string(tostring(currentQuestion - 1)) -- Select the first row
		selection:select_iter(iter)

		if currentQuestion < question.last then
			nextButton:set_visible(true)
		end
	end

    question.complete = false
	
    -- Define the callback function for the submit button in exam mode
	submitButton.on_clicked = function()
		-- runs the exam mode evaluation on all your answers
		local choice = question.mode.exam(mainWordList, w, question.last, response, replace, list)

		-- Will run if you didn't complete all questions
		if question.complete == false then
			local pop = require("lua.question.popups")
			currentQuestion = pop.are_you_sure(
				currentQuestion,
				switchQuestion,
				question,
				prevButton,
				submitButton,
				w,
				wg,
				bt,
				theme,
				font
			)
		else
			-- Move to the next question
			currentQuestion = switchQuestion(true, question, w, wg, bt)

			if currentQuestion > question.last then
				prevButton:set_visible(false)
				submitButton:set_visible(false)
			end
		end

		question.jsonSettings = {}
		json.saveSession(question.jsonSettings)
	end

	-- Single next button made for exam mode
	nextButton.on_clicked = function()
		if currentQuestion == question.last - 1 then
			nextButton:set_visible(false)
			submitButton:set_visible(true)
		end

		-- Move to the next question
		currentQuestion = switchQuestion(true, question, w, wg, bt)

		current = currentQuestion

		-- current question
		question.count_start = current

		-- Get the tree selection and set the default selection
		local selection = treeView:get_selection()
		local model = treeView:get_model()
		local iter = model:get_iter_from_string(tostring(current - 1)) -- Select the first row
		if currentQuestion <= question.last then
			selection:select_iter(iter)
		end

		for i = 1, math.min(#mainWordList, question.last) do
			local choice = w.entry_fields[i].text:lower()

			-- Remove leading spaces
			local choice = string.gsub(choice, "^%s*", "")

			-- Remove trailing spaces
			local choice = string.gsub(choice, "%s*$", "")

			question.jsonSettings.entry[choice] = i
		end
	end

	-- Get the tree selection and set the default selection
	local selection = wg.treeWidget:get_selection()
	local model = wg.treeWidget:get_model()
	if question.count_start then
		local iter = model:get_iter_from_string(tostring(question.count_start - 1)) -- Select the first row
		if iter then
			selection:select_iter(iter)
		end
	else
		local iter = model:get_iter_from_string(tostring(0)) -- Select the first row
		if iter then
			selection:select_iter(iter)
		end
	end

	-- Restart the start counter by the end so it restarts when
	-- pressing the restart button
	wordlist.count_start = 1

	-- Empty the wordlist language for next session
	wordlist.lang = nil

	return currentQuestion
end

-- Return the main function
return question
