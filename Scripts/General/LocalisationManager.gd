extends Node

func _enter_tree() -> void:
	TranslationServer.set_locale("shk") # For testing
	
	var locale = TranslationServer.get_locale()
	
	if ResourceLoader.exists("res://Localisation/"+locale+"/"+locale+"_theme.tres"):
		var parent = get_parent()
		if parent:
			for child in parent.get_children():
				if child != self and child is Control:
					child.set_theme(load("res://Localisation/"+locale+"/"+locale+"_theme.tres"))
