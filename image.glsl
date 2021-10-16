#version 150
out vec4 FragColor;

uniform sampler2D iChannel0;
uniform sampler2D iChannel1;
uniform sampler2D iChannel2;
uniform sampler2D iChannel3;
uniform samplerCube iChannel4;
uniform samplerCube iChannel5;
uniform samplerCube iChannel6;
uniform samplerCube iChannel7;
uniform vec4 iMouse;
uniform vec2 iResolution;
uniform float iTime;
uniform float gray_dark_top_1;
uniform float gray_dark_top_2;
uniform float gray_light_top_1;
uniform float gray_light_top_2;
uniform float red_dark_top_1;
uniform float red_dark_top_2;
uniform float red_light_top_1;
uniform float red_light_top_2;
uniform float green_dark_top_1;
uniform float green_dark_top_2;
uniform float green_light_top_1;
uniform float green_light_top_2;
uniform float blue_dark_top_1;
uniform float blue_dark_top_2;
uniform float blue_light_top_1;
uniform float blue_light_top_2;
uniform float gray_dark_bottom_1;
uniform float gray_dark_bottom_2;
uniform float gray_light_bottom_1;
uniform float gray_light_bottom_2;
uniform float red_dark_bottom_1;
uniform float red_dark_bottom_2;
uniform float red_light_bottom_1;
uniform float red_light_bottom_2;
uniform float green_dark_bottom_1;
uniform float green_dark_bottom_2;
uniform float green_light_bottom_1;
uniform float green_light_bottom_2;
uniform float blue_dark_bottom_1;
uniform float blue_dark_bottom_2;
uniform float blue_light_bottom_1;
uniform float blue_light_bottom_2;

#define S(a, b, c) smoothstep(a, b, c)
// #define SL(a, b, c) smoothstep(1.-a, 1.-b, c)
// #define S(a, b, c) step(a,c)
#define EPSILON .000000001

#define PI 3.1415
#define TAU (PI * 2.)
#define texture(a, b) texture(a, vec2(b.x, 1. - b.y))

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    // fragCoord.y = iResolution.y - fragCoord.y;
    vec2 uv = fragCoord/iResolution.xy;

    // Time varying pixel color
    vec3 col = 0.5 + 0.5*cos(iTime+uv.xyx+vec3(0,2,4));

    // Output to screen
    fragColor = texture(iChannel1, uv);
    
    vec4 layers[];
    layers[0] = texture(iChannel0, uv);
    layers[1] = texture(iChannel1, uv);
    layers[2] = texture(iChannel2, uv);
    
    
    vec4 top_layer = layers[0];
    vec4 bottom_layer = layers[1];
    bottom_layer = vec4(uv.x,0,0,1);
    
    // channels
    vec3 rgb_ratio = vec3(0.299 , 0.587 , 0.114);
    // rgb_ratio = vec3(.33);
    
    float top_gray = dot(top_layer.rgb, rgb_ratio);
    float top_red = top_layer.r;
    float top_green = top_layer.g;
    float top_blue = top_layer.b;
    
    float bottom_gray = dot(bottom_layer.rgb, rgb_ratio);
    float bottom_red = bottom_layer.r;
    float bottom_green = bottom_layer.g;
    float bottom_blue = bottom_layer.b;
    
    // gray_light_top_1 = 1.-gray_light_top_1;
    // gray_light_top_2 = 1.-gray_light_top_2;
    
    float top_mix = 0.;

    top_mix = mix(1., top_mix, S(gray_dark_top_1 - EPSILON, max(gray_dark_top_1,gray_dark_top_2), top_gray));
    top_mix = mix(top_mix, 1., S(min(gray_light_top_1,gray_light_top_2) - EPSILON, gray_light_top_1, top_gray));
    top_mix = mix(1., top_mix, S(red_dark_top_1 - EPSILON, max(red_dark_top_1,red_dark_top_2), top_red));
    top_mix = mix(top_mix, 1., S(min(red_light_top_1,red_light_top_2) - EPSILON, red_light_top_1, top_red));
    top_mix = mix(1., top_mix, S(green_dark_top_1 - EPSILON, max(green_dark_top_1,green_dark_top_2), top_green));
    top_mix = mix(top_mix, 1., S(min(green_light_top_1,green_light_top_2) - EPSILON, green_light_top_1, top_green));
    top_mix = mix(1., top_mix, S(blue_dark_top_1 - EPSILON, max(blue_dark_top_1,blue_dark_top_2), top_blue));
    top_mix = mix(top_mix, 1., S(min(blue_light_top_1,blue_light_top_2) - EPSILON, blue_light_top_1, top_blue));

    fragColor = mix(top_layer, layers[2], top_mix);
    
    float bottom_mix = 1.;

    bottom_mix = mix(0., bottom_mix, S(gray_dark_bottom_1 - EPSILON, max(gray_dark_bottom_1,gray_dark_bottom_2), bottom_gray));
    bottom_mix = mix(bottom_mix, 0., S(min(gray_light_bottom_1,gray_light_bottom_2) - EPSILON, gray_light_bottom_1, bottom_gray));
    bottom_mix = mix(0., bottom_mix, S(red_dark_bottom_1 - EPSILON, max(red_dark_bottom_1,red_dark_bottom_2), bottom_red));
    bottom_mix = mix(bottom_mix, 0., S(min(red_light_bottom_1,red_light_bottom_2) - EPSILON, red_light_bottom_1, bottom_red));
    bottom_mix = mix(0., bottom_mix, S(green_dark_bottom_1 - EPSILON, max(green_dark_bottom_1,green_dark_bottom_2), bottom_green));
    bottom_mix = mix(bottom_mix, 0., S(min(green_light_bottom_1,green_light_bottom_2) - EPSILON, green_light_bottom_1, bottom_green));
    bottom_mix = mix(0., bottom_mix, S(blue_dark_bottom_1 - EPSILON, max(blue_dark_bottom_1,blue_dark_bottom_2), bottom_blue));
    bottom_mix = mix(bottom_mix, 0., S(min(blue_light_bottom_1,blue_light_bottom_2) - EPSILON, blue_light_bottom_1, bottom_blue));
    
    // fragColor = vec4(bottom_mix);
    fragColor = mix(layers[2], fragColor, bottom_mix);

    // fragColor = vec4(gray_light_top_1,0,0,1);
}

void main( void ){vec4 color = vec4(0.0,0.0,0.0,1.0); mainImage(color, gl_FragCoord.xy);color.w = 1.0;FragColor = color;}
