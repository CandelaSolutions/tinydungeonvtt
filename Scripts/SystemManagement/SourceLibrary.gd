extends GridContainer

func _init() -> void:
	var paths = get_all_tres_file_paths("res://DLC")
	var sources = load_all_sources(paths)
	for source in sources:
		var button = Button.new()
		button.custom_minimum_size = Vector2(210, 297)
		button.text = source.name
		button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		if source.cover:
			button.icon = source.cover
			button.expand_icon = true
			# button.vertical_icon_alignment = VERTICAL_ALIGNMENT_BOTTOM # causes an infinite load, idk
		add_child(button)

func get_all_tres_file_paths(path: String) -> Array[String]: 
	var file_paths: Array[String] = []
	var dir = DirAccess.open(path)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		var file_path = path + "/" + file_name
		if dir.current_is_dir():
			file_paths += get_all_tres_file_paths(file_path)
		elif file_path.get_extension() == "tres":
			file_paths.append(file_path)
		file_name = dir.get_next()
	return file_paths

func load_all_sources(paths: Array[String]) -> Array[Source]:
	var sources: Array[Source] = []
	for path in paths:
		var object = load(path)
		if object is Source:
			sources.append(object)
	return sources
