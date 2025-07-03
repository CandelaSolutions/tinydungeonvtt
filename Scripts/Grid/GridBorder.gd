extends Node3D
class_name GridBorder

var borderMaterial = preload("res://Visuals/Materials/border.tres")

func _init() -> void:
	pass

# Wrapper for the generate_border function to automatically generate a border based on if a neighbour doesn't already exists
# (Should be called immediately neighbours are assigned -> relies on empty elements i.e. future neighbours are unassinged so generate those sides)
func generate_borders(sides: int = 6, radius: float = 0.05, rotation: float = PI/2)  -> void:
	var gridType = get_parent().gridType
	var halfGrid = int(gridType/2)
	var points = get_parent().points
	var closeNeighbours = get_parent().neighbours.filter(func(element): return element[0] == get_parent().neighbourType.Side)
	for i in range(gridType):
		if closeNeighbours[i].size() == 1 or str(closeNeighbours[i][1]) == "EdgeCase" or \
		closeNeighbours[i][1].points[halfGrid+1+i if i < halfGrid-1 else -halfGrid+1+i].y != points[i].y or \
		closeNeighbours[i][1].points[halfGrid+i if i < halfGrid else -halfGrid+i].y != points[i+1 if i+1<gridType else 0].y:
			generate_border(points[i], points[(i+1) if i+1<gridType else 0], sides, radius, rotation)

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

func generate_pillars(sides: int = 5, radius: float = 0.05, rotation: float = 0) -> void:
	var points = get_parent().points
	match get_parent().gridType:
		6:
			for i in range(points.size()):
				var neighbour1 = get_parent().neighbours[(2*i-2) if i < 0 else 10]
				var neighbour2 = get_parent().neighbours[2*i]
				if neighbour1.size() != 1 and neighbour2.size() != 1:
					var heights = []
					if str(neighbour1[1]) != "EdgeCase":
						heights.append(neighbour1[1].points[(i+2) if i < 4 else (i-4)].y)
					if str(neighbour2[1]) != "EdgeCase":
						heights.append(neighbour2[1].points[(i+4) if i < 2 else (i-2)].y)
					heights.append(points[i].y)
					if heights.max()-heights.min() != 0:
						generate_pillar(Vector3(points[i].x, heights.min(), points[i].z), Vector3(points[i].x, heights.max(), points[i].z), sides, radius, rotation)
	

func generate_pillar(point1: Vector3, point2: Vector3, sides: int, radius: float, rotation: float) -> void:
	var vertices = PackedVector3Array()
	var indices = PackedInt32Array()
	var normals = PackedVector3Array()

	var points1 = []
	var points2 = []
	for i in range(sides):
		var angle = i * 2 * PI / sides
		var x = radius * cos(angle) # TODO: Thicken proportential to the bending
		var y = radius * sin(angle)
		var point = Vector3(x, 0, y).rotated(Vector3(0,0,1), rotation) # rotating to user's preference
		points1.append(point + point2)
		points2.append(point + point1)
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

	var pillar_mesh_instance = MeshInstance3D.new()
	pillar_mesh_instance.mesh = arr_mesh
	pillar_mesh_instance.material_override = borderMaterial
	add_child(pillar_mesh_instance)
