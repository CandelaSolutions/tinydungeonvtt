extends Node
class_name GridLayer

var _gridtype: int # 2D Triangular:3, 2D Square:4, 2D Square:6, 3D Cube:-4
# TODO: 3D Tetrahedra
var _width: int

func _init(gridtype: int, width: int, length: int) -> void:
	_gridtype = gridtype
	_width = width
	for i in range(length * width):
		var x = int(i%width)
		var y = int(i/width)
		# Set Location (with altering z position for hex grids
		# Set neighbours
		match gridtype:
			#  This is some black magic. Do not touch.
			3:
				var cell = GridCell.new(Vector3(x - 0.5*y + (x + y)/2, 0, y * 0.75 / cos(PI / 6)), gridtype, (x%2 != y%2))
				add_child(cell)
			4:
				var cell = GridCell.new(Vector3(x, 0, y), gridtype)
				add_child(cell)
			6:
				var cell = GridCell.new(Vector3(x + (y * 0.5 - y / 2), 0, y * 0.75 / cos(PI / 6)), gridtype)
				add_child(cell)
