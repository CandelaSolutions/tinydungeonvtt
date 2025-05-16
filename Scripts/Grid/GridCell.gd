extends Node3D
class_name GridCell

var gridtype: int
var closeNeighbours: Array[GridCell] # Clockwise from 12
var farNeighbours: Array[GridCell]

func _init(origin: Vector3) -> void:
	transform.origin = origin
	# Create a new MeshInstance3D
	var mesh_instance = MeshInstance3D.new()
	
	# Create a CubeMesh
	var cube_mesh = BoxMesh.new()
	
	# Set the mesh for the MeshInstance3D
	mesh_instance.mesh = cube_mesh
	
	# Optionally, set the position of the mesh instance
	mesh_instance.position = Vector3(0, 0, 0)
	mesh_instance.scale = Vector3(0.5, 0.5, 0.5)
	
	# Add the MeshInstance3D as a child of the current Node3D
	add_child(mesh_instance)

func generate_polygon(sides: int, radius: float) -> Array:
	var points = []
	radius = radius / cos(PI / sides)  # Calculate the outer radius
	
	for i in range(sides):
		var angle = i * 2 * PI / sides
		var x = radius * cos(angle)
		var y = radius * sin(angle)
		points.append(Vector2(x, y))
	
	return points
