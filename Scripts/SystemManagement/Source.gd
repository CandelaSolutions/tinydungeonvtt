extends Resource
class_name Source

@export var name: String
@export_file("*.md") var text: String

@export_category("System Information")
@export var system: System
@export var core: bool
@export_enum("Canon", "Non-Canon") var canonicity: String

@export_category("Publishing Information")
@export var publisher: String
@export var datePublished: String
@export var ISBN: String
@export var DriveThruRpgID: int
@export var pageCount: int
@export var previousVersion: Source
