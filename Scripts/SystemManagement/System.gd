extends Resource
class_name System

@export var name: String
@export var version: String

@export_category("Play Information")
@export_enum("d4:4", "d6:6", "d8:8", "d10:10", "d12:12", "d20:20") var die: int
