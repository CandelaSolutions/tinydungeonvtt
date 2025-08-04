@tool
extends LineEdit

@onready var logsContainer = $ScrollContainer/VBoxContainer

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1:
		var evLocal = make_input_local(event)
		if !Rect2(Vector2(0,0), size).has_point(evLocal.position):
			release_focus()

func _on_text_submitted(new_text: String) -> void:
	var label = Label.new()
	label.text = new_text
	logsContainer.add_child(label)
	clear()
	release_focus()
