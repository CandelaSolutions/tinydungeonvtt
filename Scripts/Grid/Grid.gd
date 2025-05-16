extends Node
class_name Grid

func _ready() -> void:
	var layer_0 = GridLayer.new(6, 6, 6)
	add_child(layer_0)
