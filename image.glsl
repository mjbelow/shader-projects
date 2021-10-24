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


bool stroke(float a)
{
  return (a < 1. && a > .95);
}

float sdf_circle(vec2 uv, float r)
{
    return length(uv)-r;
    return sqrt(uv.x*uv.x+uv.y*uv.y);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = (fragCoord*2.-iResolution.xy)/iResolution.y;

    // Time varying pixel color
    //vec3 col = 0.5 + 0.5*cos(iTime+uv.xyx+vec3(0,2,4));

    vec3 col = vec3(.8);

    uv *= 2.;
    
    uv = fract(uv);
    
    uv += vec2(-.5);
    
    float r = tan(iTime*.25)*.25-.75;
    
    float circle1 = sdf_circle(uv, r);
    
    
    if(stroke(circle1))
        col = vec3(1,0,0);

    // Output to screen
    fragColor = vec4(col,1.0);
}

void main( void ){vec4 color = vec4(0.0,0.0,0.0,1.0); mainImage(color, gl_FragCoord.xy);color.w = 1.0;FragColor = color;}
