extends Node
class_name GridLayer

var _gridtype: int # 2D Triangular:3, 2D Square:4, 2D Square:6, 3D Cube:-4
# TODO: 3D Tetrahedra
var _width: int

func _init(gridtype: int, width: int, length: int) -> void:
	_gridtype = gridtype
	_width = width
	for i in range(length * width):
		print(i%width)
		print(i/width)
		# Set Location (with altering z position for hex grids)
		var cell = GridCell.new(Vector3(i%width, 0, i/width))
		add_child(cell)
		# Set neighbours
		match gridtype:
			3:
				pass
			4:
				pass
			6:
				pass
