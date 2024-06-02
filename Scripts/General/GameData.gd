extends Node3D

const commandTheme = preload("res://Visuals/Fonts/Themes/commandTheme.tres")
const commandOverride = preload("res://Visuals/LabelSettings/commandOverride.tres")

@onready var CommandLine = $CommandPrompt/CommandLine
@onready var CommandContainer = $CommandPrompt/ScrollContainer
@onready var PreviousCommands = $CommandPrompt/ScrollContainer/PreviousCommands

func _on_command_line_command_sent(text: String) -> void:
	text.strip_edges()
	if (text.is_empty()):
		pass
	elif (text[0] == '/'):
		PreviousCommands.add_child(PreviousCommand(_on_command_entered(text)))
	else:
		PreviousCommands.add_child(PreviousCommand(text))

func _on_command_entered(text: String) -> String:
	text = text.replace(" ","")
	text = text.replace("	","")
	text = text.replace("/","")
	if (text.substr(0,4) == "roll"):
		return "Rolled"
	return "Command (" + text + ") Unrecognised"
	
func RollCommand(text: String) -> String:
	return text

func PreviousCommand(text: String) -> RichTextLabel:
	var previousCommand = RichTextLabel.new()
	previousCommand.add_text(text)
	previousCommand.fit_content = true
	previousCommand.scroll_active = false
	#previousCommand.set_autowrap_mode(TextServer.AUTOWRAP_WORD_SMART)
	previousCommand.theme = commandTheme
	previousCommand.add_theme_stylebox_override("normal", commandOverride)
	return previousCommand
