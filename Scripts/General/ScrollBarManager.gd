extends ScrollContainer

@onready var Scrollbar = get_v_scroll_bar()

func _ready():
	Scrollbar.changed.connect(_when_scrollbar_changed)
	
func _when_scrollbar_changed():
	scroll_vertical = Scrollbar.max_value
