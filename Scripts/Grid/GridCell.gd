extends Node3D
class_name GridCell

var gridtype: int
var closeNeighbours: Array[GridCell] # Clockwise from 12
var farNeighbours: Array[GridCell]

var points: Array = []
var borderMaterial = preload("res://Visuals/Materials/border.tres")

func _init(origin: Vector3, type: int, flip: bool = false) -> void:
	transform.origin = origin
	var mesh_instance = MeshInstance3D.new()
	var points
	
	# Set the mesh for the MeshInstance3D
	if flip:
		points = generate_points(type, 1, PI - PI/type)
	else:
		points = generate_points(type, 1)
	
	mesh_instance.mesh = generate_cell_mesh(points)
	mesh_instance.scale = Vector3(0.5, 0.5, 0.5)
	
	# Add the MeshInstance3D as a child of the current Node3D
	add_child(mesh_instance)
	
	var border_mesh_instance_0 = MeshInstance3D.new()
	border_mesh_instance_0.mesh = generate_border_mesh(points[0], points[1], 4, 0.05, PI/2)
	border_mesh_instance_0.material_override = borderMaterial
	add_child(border_mesh_instance_0)
	var border_mesh_instance_1 = MeshInstance3D.new()
	border_mesh_instance_1.mesh = generate_border_mesh(points[1], points[2], 4, 0.05, PI/2)
	border_mesh_instance_1.material_override = borderMaterial
	add_child(border_mesh_instance_1)
	var border_mesh_instance_2 = MeshInstance3D.new()
	border_mesh_instance_2.mesh = generate_border_mesh(points[2], points[0], 4, 0.05, PI/2)
	border_mesh_instance_2.material_override = borderMaterial
	add_child(border_mesh_instance_2)

# --------------------------------- Functions ---------------------------------

func generate_points(sides: int, radius: float = 1, rotation: float = PI/sides) -> Array:
	var points = []
	radius = radius / cos(PI / sides)  # Calculate the outer radius
	
	for i in range(sides):
		var angle = i * 2 * PI / sides
		var x = radius * cos(angle)
		var y = radius * sin(angle)
		points.append(Vector3(x, 0, y).rotated(Vector3(0, 1, 0), rotation))
	
	return points

func generate_cell_mesh(points: Array) -> Mesh:
	var vertices = PackedVector3Array()
	var indices = PackedInt32Array()
	for i in range(points.size()):
		vertices.append(points[i])
		if i > 1:
			indices.append(0)
			indices.append(i-1)
			indices.append(i)

	# Initialize the ArrayMesh.
	var arr_mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_INDEX] = indices

	# Create the Mesh.
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	return arr_mesh

func generate_border_mesh(point1: Vector3, point2: Vector3, sides: int, radius: float, rotation: float = 0) -> Mesh:
	var vertices = PackedVector3Array()
	var indices = PackedInt32Array()
	var normals = PackedVector3Array()

	var points1 = []
	var points2 = []
	for i in range(sides):
		var angle = i * 2 * PI / sides
		var x = radius * cos(angle) * 1 # TODO: Thicken proportential to the bending
		var y = radius * sin(angle)
		var point = Vector3(x, y, 0).rotated(Vector3(0,0,1), rotation) # rotating to user's preference
		var a = point.rotated(Vector3(0,1,0), -atan2(point1.z - y, point1.x - x)) + point1/2
		var b = point.rotated(Vector3(0,1,0), -atan2(point2.z - y, point2.x - x)) + point2/2
		points1.append(a)
		points2.append(b)
		normals.append(point.normalized())
		normals.append(point.normalized())

	for i in range(points1.size()):
		vertices.append(points1[i])
		vertices.append(points2[i])
		if i > 0:
			indices.append(2*(i-1))
			indices.append(2*(i-1)+1)
			indices.append(2*(i-1)+3)
			indices.append(2*(i-1)+3)
			indices.append(2*(i-1)+2)
			indices.append(2*(i-1))
	indices.append(2*points1.size()-2)
	indices.append(2*points1.size()-1)
	indices.append(1)
	indices.append(1)
	indices.append(0)
	indices.append(2*points1.size()-2)

	# Initialize the ArrayMesh.
	var arr_mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_INDEX] = indices
	arrays[Mesh.ARRAY_NORMAL] = normals
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	return arr_mesh
