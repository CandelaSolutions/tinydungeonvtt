extends Node3D
class_name GridCell

var gridType: int
var neighbours: Array[Array] = []
enum neighbourType {Side, Corner, CornerAlt}
var points: Array = []
var border: GridBorder
var cornerHeight: Array[float] = []

func _init(origin: Vector3, type: int, flip: bool = false) -> void:
	cornerHeight = [0,0,0,0,0,0]
	transform.origin = origin
	gridType = type

	if flip:
		points = generate_points(gridType, 0.4, PI - PI/gridType)
	else:
		points = generate_points(gridType, 0.4)

	generate_empty_neighbours_list(flip)

	border = GridBorder.new()
	add_child(border)

# --------------------------------- Functions ---------------------------------

# Generate the array of Vector3s that hold the corner positions (Vital for everthing else!!!!)
func generate_points(sides: int, radius: float = 0.5, rotation: float = PI/sides) -> Array:
	var points = []
	radius = radius / cos(PI / sides)  # Calculate the inner radius (should be 1m from cell centre -> through flat side -> to cell centre)
	
	for i in range(sides):
		var angle = i * 2 * PI / sides
		var x = radius * cos(angle)
		var y = radius * sin(angle)
		points.append(Vector3(x, cornerHeight[i], y).rotated(Vector3(0, 1, 0), rotation))
	return points

# Generates the Cell Mesh
func generate_cell(material: Material = null) -> void:
	var mesh_instance = MeshInstance3D.new()
	var vertices = PackedVector3Array()
	var indices = PackedInt32Array()
	var normals = PackedVector3Array()
	
	# I can't believe there's no avg function for arrays
	var centreHight = 0
	for height in cornerHeight:
		centreHight += height
	centreHight /= cornerHeight.size()
	
	vertices.append(Vector3(0, centreHight, 0))
	for i in range(points.size()):
		vertices.append(points[i])
		if i > 0:
			indices.append(0)
			indices.append(i)
			indices.append(i+1)
	
	indices.append(0)
	indices.append(points.size())
	indices.append(1)

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
		
func generate_empty_neighbours_list(flip : bool):
	match gridType:
		3:
			neighbours.resize(12)
			neighbours[0].append(neighbourType.CornerAlt)
			neighbours[2].append(neighbourType.CornerAlt)
			neighbours[4].append(neighbourType.CornerAlt)
			neighbours[6].append(neighbourType.CornerAlt)
			neighbours[8].append(neighbourType.CornerAlt)
			neighbours[10].append(neighbourType.CornerAlt)
			if flip:
				neighbours[1].append(neighbourType.Side)
				neighbours[3].append(neighbourType.Corner)
				neighbours[5].append(neighbourType.Side)
				neighbours[7].append(neighbourType.Corner)
				neighbours[9].append(neighbourType.Side)
				neighbours[11].append(neighbourType.Corner)
			else:
				neighbours[1].append(neighbourType.Corner)
				neighbours[3].append(neighbourType.Side)
				neighbours[5].append(neighbourType.Corner)
				neighbours[7].append(neighbourType.Side)
				neighbours[9].append(neighbourType.Corner)
				neighbours[11].append(neighbourType.Side)
		4:
			neighbours.resize(8)
			neighbours[0].append(neighbourType.Side)
			neighbours[1].append(neighbourType.Corner)
			neighbours[2].append(neighbourType.Side)
			neighbours[3].append(neighbourType.Corner)
			neighbours[4].append(neighbourType.Side)
			neighbours[5].append(neighbourType.Corner)
			neighbours[6].append(neighbourType.Side)
			neighbours[7].append(neighbourType.Corner)
		6:
			neighbours.resize(12)
			neighbours[0].append(neighbourType.Side)
			neighbours[1].append(neighbourType.Corner)
			neighbours[2].append(neighbourType.Side)
			neighbours[3].append(neighbourType.Corner)
			neighbours[4].append(neighbourType.Side)
			neighbours[5].append(neighbourType.Corner)
			neighbours[6].append(neighbourType.Side)
			neighbours[7].append(neighbourType.Corner)
			neighbours[8].append(neighbourType.Side)
			neighbours[9].append(neighbourType.Corner)
			neighbours[10].append(neighbourType.Side)
			neighbours[11].append(neighbourType.Corner)

func assign_neighbour(direction: int, neighbour: GridCell, halfStepDirection: int = -1, negativeHalfStepDirection: int = -1, calculateOpposite: bool = true) -> void:
	neighbours[direction].append(neighbour)
	neighbours[direction].append(halfStepDirection)
	
	if !calculateOpposite:
		return
	
	var oppositeDirection = 0
	if direction - len(neighbours)/2 >= 0:
		oppositeDirection = direction - len(neighbours)/2
	else:
		oppositeDirection = direction + len(neighbours)/2
	
	neighbour.assign_neighbour(oppositeDirection, self, negativeHalfStepDirection, -1, false)
