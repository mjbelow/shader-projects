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
    fragCoord.y = iResolution.y - fragCoord.y;
    vec2 uv = fragCoord/iResolution.xy;

    // Time varying pixel color
    vec3 col = 0.5 + 0.5*cos(iTime+uv.xyx+vec3(0,2,4));

    // Output to screen
    fragColor = texture(iChannel1, uv);
    float base_green = texture(iChannel1, uv).g;
    
    if (base_green < cos(iTime/3.)*.55+.45)
        fragColor = vec4(0);
}

void main( void ){vec4 color = vec4(0.0,0.0,0.0,1.0); mainImage(color, gl_FragCoord.xy);color.w = 1.0;FragColor = color;}