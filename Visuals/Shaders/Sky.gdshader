shader_type sky;

uniform vec3 skyColour : source_color;

void sky() {
	COLOR = EYEDIR;
}