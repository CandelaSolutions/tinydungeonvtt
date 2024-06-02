extends CodeEdit

signal CommandSent(text: String)

const commands = ["/join", "/roll"]

func _ready():
	set_code_completion_prefixes(["/"])

func _on_text_changed() -> void:
	for i in commands:
		add_code_completion_option(CodeEdit.KIND_PLAIN_TEXT, i, i)
	update_code_completion_options(true)
	if (text.length() > 0 && text[text.length() - 1] == '\n' && !Input.is_key_pressed(KEY_CTRL)):
		text = text.left(text.length() - 1)
		CommandSent.emit(text)
		print(text)
		clear()
