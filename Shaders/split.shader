shader_type canvas_item;

uniform float dissonance;
uniform vec4 col1;
uniform vec4 col2;

void fragment(){
	vec4 col = texture(TEXTURE,UV+vec2(dissonance,0))*col1/(col1+col2);
	col += texture(TEXTURE,UV+vec2(-1f*dissonance,0))*col2/(col1+col2);
	COLOR = col;
	
}