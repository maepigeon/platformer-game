shader_type canvas_item;
render_mode unshaded;


uniform float aspect_ratio = 1.5;
uniform vec2 pos;
uniform float rad : hint_range(0.0, 2.0);

float circle(vec2 uv, float r) {
	float d = length(uv);
	float color = 0.0;
	return step(d, r);
}

void fragment() {
	vec2 uv = UV - 0.5;	//UV - vec2(0.5)
	uv.x *= aspect_ratio;
	float c1 = circle(uv+pos, rad);

	COLOR = vec4(vec3(0.), 1. - c1);
}