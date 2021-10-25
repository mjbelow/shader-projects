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
    //vec2 uv = (fragCoord*2.-1.*iResolution.xy)/iResolution.x;
    //vec2 uv = (fragCoord*1.-.5*iResolution.xy)/iResolution.x;
    vec2 uv = (fragCoord)/iResolution.x;

    // Time varying pixel color
    vec3 col = 0.5 + 0.5*cos(iTime+uv.xyx+vec3(0,2,4));

    uv *= 5.;
    
    //uv = floor(uv);
    
    //uv /= 10.;
    
    int m = int(uv.x);
    
    uv = fract(uv);
    
    uv.y *= 5.;
    uv.y = floor(uv.y);
    uv.y /= 5.;

    // Output to screen
    
    if(m % 2 == 0)
        fragColor = vec4(uv.x,uv.y,uv.y,1.0);
    else
        fragColor = vec4(uv.y,uv.x,uv.x,1.0);
    
    if(uv.y==.6)
        fragColor = vec4(0);
}

void main( void ){vec4 color = vec4(0.0,0.0,0.0,1.0); mainImage(color, gl_FragCoord.xy);color.w = 1.0;FragColor = color;}
