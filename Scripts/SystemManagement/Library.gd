extends Control

const bookshelfTextureLocation = "C:/Users/judeh/Downloads/oak-3275-mm-architextures.jpg"
const LibraryLocation = "C:/Users/judeh/Documents/GitHub/TTRPGs"

var bookshelfTexture

func _ready():
	texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	bookshelfTexture = loadTexture(bookshelfTextureLocation)
	#text = array_to_string(get_all_files(LibraryLocation, "md"))

func _draw():
	draw_texture(bookshelfTexture, Vector2())

func loadTexture(path):
	var img = Image.new()
	img.load(path)
	return ImageTexture.create_from_image(img)

func get_all_files(path: String, file_ext := "", files := []):
	var dir = DirAccess.open(path)
	if DirAccess.get_open_error() == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				var i = dir.get_current_dir()
				files = get_all_files(i +"/"+ file_name, file_ext, files)
			else:
				if file_ext and file_name.get_extension() != file_ext:
					file_name = dir.get_next()
					continue
				
				#files.append(dir.get_current_dir() +"/"+ file_name)
				files.append(file_name.left(file_name.length() - 3))
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access %s." % path)
	return files

func array_to_string(arr: Array) -> String:
	var s = ""
	arr.sort()
	for i in arr:
		s += String(i) + "\n"
	return s
