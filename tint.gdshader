shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform vec4 tint_color : source_color = vec4(1.0, 0.0, 0.0, 1.0); // Default Red
uniform float saturation : hint_range(0.0, 1.0) = 0.0;           // 0.0 is full gray
uniform float mix_amount : hint_range(0.0, 1.0) = 0.5;           // Intensity of the tint

void fragment() {
    vec4 tex_color = texture(SCREEN_TEXTURE, SCREEN_UV);
    
    float luminance = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));
    vec3 grayscale = vec3(luminance);
    
    vec3 base_color = mix(grayscale, tex_color.rgb, saturation);
    
    vec3 tinted_result = base_color * tint_color.rgb;
    
    COLOR.rgb = mix(base_color, tinted_result, mix_amount);
    COLOR.a = tex_color.a;
}