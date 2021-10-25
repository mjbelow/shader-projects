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


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.y;

    // Time varying pixel color
    vec3 col = vec3(0);
    
    //uv.x = 1. - uv.x;
    uv = 1. - uv;
    
    uv *= 10.99;
    uv = floor(uv);
    uv /= 10.99;
    
    col = vec3((uv.y+uv.x)/2.);
    
    col *= vec3(0.5,0.75,1);

    // Output to screen
    fragColor = vec4(col,1.0);
}

void main( void ){vec4 color = vec4(0.0,0.0,0.0,1.0); mainImage(color, gl_FragCoord.xy);color.w = 1.0;FragColor = color;}
