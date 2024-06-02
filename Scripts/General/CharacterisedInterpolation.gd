@tool
extends Node3D

class_name CharacterisedInterpolationProfile
# https://youtu.be/KPoeNZZ6H4s?si=NUGIMIEjAy6yK5SO

# Usage guide:
# Set destination, not position
# Use export values to control type of motion

@export var frequency : float :
	set(value):
		frequency = clamp(value, 0, 10) # make sure this is never 0
		if value == 0:
			value = 0.01
		
@export var damping : float
@export var response : float

var k1 : float :
	get :
		if (frequency == 0):
			return 0
		else:
			return damping / (PI * frequency)

var k2 : float :
	get :
		if (frequency == 0):
			return 0
		else:
			return 1 / ((2 * PI * frequency) * (2 * PI * frequency))

var k3 : float :
	get:
		if (frequency == 0):
			return 0
		else:
			return response * damping / (2 * PI * frequency)

@export var destination : Transform3D
@export var speed : float :
	set(value):
		speed = clamp(value, 0, 10)
		if value == 0:
			value = 0.01
		
var previousInput : Transform3D # previous input
var outputTransform : Transform3D # position
var outputVelocity : Vector3 # velocity
var outputAngularVelocity : Basis

func _init() -> void:
	previousInput = transform
	outputTransform = transform
	outputVelocity = Vector3.ZERO
	outputAngularVelocity = Basis.IDENTITY
	frequency = 0.5
	
func _process(delta: float) -> void:
	delta *= speed
	
	var inputVelocity = (destination.origin - previousInput.origin) / delta
	var inputAngularVelocity = sub_basis(destination.basis, previousInput.basis) * (1 / delta)
	previousInput = destination
	
	var k2stable = max(k2, delta * delta / 2 + delta * k1 / 2, delta * k1)
	
	outputTransform.origin += delta * outputVelocity
	outputTransform.basis = add_basis(outputTransform.basis, outputAngularVelocity * delta)
	outputVelocity += delta * (destination.origin + k3 * inputVelocity - outputTransform.origin - k1 * outputVelocity) / k2stable
	outputAngularVelocity = add_basis(outputAngularVelocity, sub_basis(add_basis(destination.basis, inputAngularVelocity * -k3), sub_basis(outputTransform.basis, outputAngularVelocity * -k1)))
	transform.origin = outputTransform.origin
	transform.basis = outputTransform.basis
	
static func add_basis(lhs: Basis, rhs: Basis) -> Basis:
	return Basis(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)

static func sub_basis(lhs: Basis, rhs: Basis) -> Basis:
	return Basis(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)

#static func chrp(start: Vector3, end: Vector3, delta: float) -> Vector3:
#	return start + (end - start) * delta
