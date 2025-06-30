extends Node3D
class_name GridBorder

var borderMaterial = preload("res://Visuals/Materials/border.tres")

func _init() -> void:
	pass

# Wrapper for the generate_border function to automatically generate a border based on if a neighbour doesn't already exists
# (Should be called immediately neighbours are assigned -> relies on empty elements i.e. future neighbours are unassinged so generate those sides)
func generate_borders(sides: int = 6, radius: float = 0.05, rotation: float = PI/2)  -> void:
	var closeNeighbours = get_parent().neighbours.filter(func(element): return element[0] == get_parent().neighbourType.Side)
	for i in range(get_parent().gridType):
		if closeNeighbours[i].size() == 1:
			var j: int
			if i+1 == get_parent().gridType:
				j = 0
			else:
				j = i+1
			generate_border(get_parent().points[i], get_parent().points[j], sides, radius, rotation)

# Generates the Border Mesh for 1 side, between 2 points
func generate_border(point1: Vector3, point2: Vector3, sides: int, radius: float, rotation: float) -> void:
	var vertices = PackedVector3Array()
	var indices = PackedInt32Array()
	var normals = PackedVector3Array()

	var points1 = []
	var points2 = []
	for i in range(sides):
		var angle = i * 2 * PI / sides
		var x = radius * cos(angle) # TODO: Thicken proportential to the bending
		var y = radius * sin(angle)
		var point = Vector3(x, y, 0).rotated(Vector3(0,0,1), rotation) # rotating to user's preference
		var a = point.rotated(Vector3(0,1,0), -atan2(point1.z - y, point1.x - x)) + point1
		var b = point.rotated(Vector3(0,1,0), -atan2(point2.z - y, point2.x - x)) + point2
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
