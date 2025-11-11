extends Camera3D

class_name BoomCamera

@export var centredLocation: Vector3
@export var overrideCentredObject: Node3D

@export var horizontalRotation: float
@export var verticalRotation: float
@export var boomLength: float = 10
@export var autoBoom: bool

static var direction0 = Vector3(0, 0, -1)

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("BoomCameraTurnLeft"):
		horizontalRotation -= 0.02
	if Input.is_action_pressed("BoomCameraTurnRight"):
		horizontalRotation += 0.02
	if Input.is_action_pressed("BoomCameraTurnDown"):
		if verticalRotation >= PI/-2 + 0.03:
			verticalRotation -= 0.02
	if Input.is_action_pressed("BoomCameraTurnUp"):
		if verticalRotation <= PI/2 - 0.03:
			verticalRotation += 0.02
	print(verticalRotation)

	var direction = (centredLocation - transform.origin).normalized()
	var angle = acos(direction0.dot(direction))
	var axis_of_rotation = direction0.cross(direction).normalized()
	var rotation_destination = Quaternion(axis_of_rotation, angle).get_euler()
	
	transform.origin = centredLocation + (direction0 * boomLength).rotated(Vector3(1,0,0), verticalRotation).rotated(Vector3(0,1,0), horizontalRotation)
	
	rotation = Vector3(rotation_destination.x, rotation_destination.y, 0)
