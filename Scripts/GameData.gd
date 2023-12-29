extends Node3D

@onready var CommandLine = $CommandPrompt/CommandLine
@onready var PreviousCommands = $CommandPrompt/PreviousCommands

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func PreviousCommand(text: String) -> Label:
	var previousCommand = Label.new()
	previousCommand.text = text
	return previousCommand
