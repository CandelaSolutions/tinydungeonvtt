@tool
extends LineEdit

@onready var scroll = $ScrollContainer
@onready var scrollbar : VScrollBar = scroll.get_v_scroll_bar()
@onready var logsContainer = $ScrollContainer/VBoxContainer

func _ready() -> void:
	scrollbar.connect("changed", scrollbar_changed)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1:
		var evLocal = make_input_local(event)
		if !Rect2(Vector2(0,0), size).has_point(evLocal.position):
			call_deferred("release_focus")

func _on_text_submitted(new_text: String) -> void:
	var label = Label.new()
	label.text = new_text
	logsContainer.add_child(label)
	clear()
	release_focus()

func scrollbar_changed() -> void:
	scroll.scroll_vertical = scrollbar.max_value
