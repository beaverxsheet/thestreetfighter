shader_type canvas_item;
render_mode unshaded;

uniform float opac: hint_range(0, 1);

void fragment(){
	COLOR = texture(TEXTURE, UV);
	COLOR.a = opac;
}