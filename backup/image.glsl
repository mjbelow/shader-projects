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
uniform float gray_dark_1;
uniform float gray_dark_2;
uniform float gray_light_1;
uniform float gray_light_2;
uniform float red_dark_1;
uniform float red_dark_2;
uniform float red_light_1;
uniform float red_light_2;
uniform float green_dark_1;
uniform float green_dark_2;
uniform float green_light_1;
uniform float green_light_2;
uniform float blue_dark_1;
uniform float blue_dark_2;
uniform float blue_light_1;
uniform float blue_light_2;

#define S(a, b, c) smoothstep(a, b, c)
// #define SL(a, b, c) smoothstep(1.-a, 1.-b, c)
// #define S(a, b, c) step(a,c)
#define EPSILON .000000001

#define PI acos(-1.)
#define TAU (PI * 2.)
#define texture(a, b) texture(a, vec2(b.x, 1. - b.y))

#define gray_light_1 (1.-gray_light_1)
#define gray_light_2 (1.-gray_light_2)

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    // fragCoord.y = iResolution.y - fragCoord.y;
    vec2 uv = fragCoord/iResolution.xy;

    // Time varying pixel color
    vec3 col = 0.5 + 0.5*cos(iTime+uv.xyx+vec3(0,2,4));

    // Output to screen
    fragColor = texture(iChannel1, uv);
    
    
    vec4 top_layer = texture(iChannel1, uv);
    vec4 bottom_layer = texture(iChannel1, uv);
    
    // channels
    float top_gray = dot(top_layer.rgb, vec3(.33,.33,.33));
    float top_red = top_layer.r;
    float top_green = top_layer.g;
    float top_blue = top_layer.b;
    
    float bottom_gray = dot(bottom_layer.rgb, vec3(.33,.33,.33));
    float bottom_red = bottom_layer.r;
    float bottom_green = bottom_layer.g;
    float bottom_blue = bottom_layer.b;
    
    // gray_light_1 = 1.-gray_light_1;
    // gray_light_2 = 1.-gray_light_2;
    

    fragColor = mix(vec4(1,0,0,1), fragColor, S(gray_dark_1 - EPSILON, max(gray_dark_1,gray_dark_2), top_gray));
    fragColor = mix(fragColor, vec4(1,0,0,1), S(min(gray_light_1,gray_light_2) - EPSILON, gray_light_1, top_gray));
    
    fragColor = mix(vec4(1,0,0,1), fragColor, S(red_dark_1 - EPSILON, max(red_dark_1,red_dark_2), top_red));
    fragColor = mix(fragColor, vec4(1,0,0,1), S(min(red_light_1,red_light_2) - EPSILON, red_light_1, top_red));
    
    fragColor = mix(vec4(1,0,0,1), fragColor, S(green_dark_1 - EPSILON, max(green_dark_1,green_dark_2), top_green));
    fragColor = mix(fragColor, vec4(1,0,0,1), S(min(green_light_1,green_light_2) - EPSILON, green_light_1, top_green));
    
    fragColor = mix(vec4(1,0,0,1), fragColor, S(blue_dark_1 - EPSILON, max(blue_dark_1,blue_dark_2), top_blue));
    fragColor = mix(fragColor, vec4(1,0,0,1), S(min(blue_light_1,blue_light_2) - EPSILON, blue_light_1, top_blue));
    // fragColor = vec4(gray_light_1,0,0,1);
}

void main( void ){vec4 color = vec4(0.0,0.0,0.0,1.0); mainImage(color, gl_FragCoord.xy);color.w = 1.0;FragColor = color;}
