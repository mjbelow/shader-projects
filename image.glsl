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


#define PI acos(-1.)
#define TAU 2.*PI

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    //fragCoord = iResolution.xy - fragCoord.xy;
    //fragCoord.x = iResolution.x - fragCoord.x;
    
    vec2 uv = fragCoord.xy/iResolution.xy;
    uv.x = (fragCoord.x*2.-1.*iResolution.x)/iResolution.x;
    uv.y = (fragCoord.y*2.-1.*iResolution.y)/iResolution.y;

    // Time varying pixel color
    vec3 col = 0.5 + 0.5*cos(iTime+uv.xyx+vec3(0,2,4));

    // Output to screen
    fragColor = vec4(col,1.0);
    
    //if(sin(uv.x*TAU)*.5+.5 > uv.y)
    if(pow(uv.x-iTime,3.) > uv.y)
        fragColor = vec4(0);
    
    //fragColor = texture(iChannel0, uv);
}

void main( void ){vec4 color = vec4(0.0,0.0,0.0,1.0); mainImage(color, gl_FragCoord.xy);color.w = 1.0;FragColor = color;}
