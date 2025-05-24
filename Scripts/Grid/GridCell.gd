extends Node3D
class_name GridCell

var gridType: int
var neighbours: Array = []
var points: Array = []
var borderMaterial = preload("res://Visuals/Materials/border.tres")

func _init(origin: Vector3, type: int, flip: bool) -> void:
	transform.origin = origin
	gridType = type
	if flip:
		points = generate_points(gridType, 0.5, PI - PI/gridType)
	else:
		points = generate_points(gridType, 0.5)
	match gridType:
		3:
			# N(close/farCorner), NE(far), E(close), EE(far), ESE(farCorner), SE(far), S(farCorner/close), SW(far), WSW(farCorner), WW(far), W(close), NW(far)
			neighbours.resize(12)
		4:
			# N(close), NE(far), E(close), SE(far), S(close), SW(far), W(close), NW(far)
			neighbours.resize(8)
		6:
			# N(far), NNE(close), NE(far), E(close), SE(far), SSE(close), S(far), SSW(close), SW(far), W(close), NW(far), NNW(close)
			neighbours.resize(12)

# --------------------------------- Functions ---------------------------------

# Generate the array of Vector3s that hold the corner positions (Vital for everthing else!!!!)
func generate_points(sides: int, radius: float = 0.5, rotation: float = PI/sides) -> Array:
	var points = []
	radius = radius / cos(PI / sides)  # Calculate the inner radius (should be 1m from cell centre -> through flat side -> to cell centre)
	
	for i in range(sides):
		var angle = i * 2 * PI / sides
		var x = radius * cos(angle)
		var y = radius * sin(angle)
		points.append(Vector3(x, 0, y).rotated(Vector3(0, 1, 0), rotation))
	return points

# Generates the Cell Mesh
func generate_cell(material: Material = null) -> void:
	var mesh_instance = MeshInstance3D.new()
	var vertices = PackedVector3Array()
	var indices = PackedInt32Array()
	for i in range(points.size()):
		vertices.append(points[i])
		if i > 1:
			indices.append(0)
			indices.append(i-1)
			indices.append(i)

	var arr_mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_INDEX] = indices
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	mesh_instance.mesh = arr_mesh
	if material:
		mesh_instance.material_override = material
	add_child(mesh_instance)

# Generates the Border Mesh for 1 side, between 2 points
func generate_border(point1: Vector3, point2: Vector3, sides: int, radius: float, rotation: float) -> void:
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

	var arr_mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_INDEX] = indices
	arrays[Mesh.ARRAY_NORMAL] = normals
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)

	var border_mesh_instance = MeshInstance3D.new()
	border_mesh_instance.mesh = arr_mesh
	border_mesh_instance.material_override = borderMaterial
	add_child(border_mesh_instance)

# Wrapper for the generate_border function to automatically generate a border based on if a neighbour doesn't already exists
# (Should be called immediately neighbours are assigned -> relies on empty elements i.e. future neighbours are unassinged so generate those sides)
func generate_borders(sides: int = 6, radius: float = 0.05, rotation: float = PI/2),  -> void:
	closeNeighbours = arr.filter(func(element): return element.distance != 'farCorner' || element.distance != 'far')
	for i in range(gridType):
		if closeNeighbours[i] != null:
			pass
		var j: int
		if i+1 == gridType:
			j = 0
		else:
			j = i+1
		generate_border(points[i], points[j], sides, radius, rotation)

func assign_neighbour(neighbour: GridCell, direction: int) -> void:
	neighbours[i] = neighbour
	neighbours[i].neighbours[i-6] = this
