extends Node
class_name Grid

func _ready() -> void:
	var layer_0 = GridLayer.new(4, 24, 24)
	add_child(layer_0)
