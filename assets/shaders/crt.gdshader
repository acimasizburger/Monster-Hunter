shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float scanline_strength : hint_range(0.0, 1.0) = 0.22;
uniform float curvature : hint_range(0.0, 0.1) = 0.02;
uniform float vignette_strength : hint_range(0.0, 1.0) = 0.25;
uniform float chromatic_aberration : hint_range(0.0, 3.0) = 0.6;

vec2 curve_uv(vec2 uv) {
	uv = uv * 2.0 - 1.0;
	vec2 offset = abs(uv.yx) * curvature;
	uv = uv + uv * offset * offset;
	uv = uv * 0.5 + 0.5;
	return uv;
}

void fragment() {
	vec2 uv = curve_uv(SCREEN_UV);
	
	if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
		COLOR = vec4(0.0, 0.0, 0.0, 1.0);
	} else {
		vec2 pixel_offset = vec2(chromatic_aberration / 320.0, 0.0);
		float r = texture(screen_texture, uv + pixel_offset).r;
		float g = texture(screen_texture, uv).g;
		float b = texture(screen_texture, uv - pixel_offset).b;
		vec3 col = vec3(r, g, b);
		
		float scanline = sin(uv.y * 180.0 * PI * 2.0) * 0.5 + 0.5;
		col *= 1.0 - (scanline * scanline_strength);
		
		vec2 vig_uv = uv * (1.0 - uv.yx);
		float vig = vig_uv.x * vig_uv.y * 15.0;
		vig = pow(clamp(vig, 0.0, 1.0), vignette_strength);
		col *= vig;
		
		COLOR = vec4(col, 1.0);
	}
}