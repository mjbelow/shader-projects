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


#define pi acos(-1.)

float sdBox( in vec2 p, in vec2 b )
{
    vec2 d = abs(p)-b;
    return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.y;
    
    float t = iTime;
    
    //t = .25 * pi;
    
    mat2 m = mat2
    (
    cos(t), sin(t),
    -sin(t), cos(t)
    );
    
    //uv *= m;
    
    uv *= 20.;
    
    uv = mod(uv, 4.);
    
    vec2 p = uv - vec2(2);
    
    p = p * m;

    // Time varying pixel color
    vec3 col = 0.5 + 0.5*cos(iTime+uv.xyx+vec3(0,2,4));
    
    float d = sdBox(p, vec2(1.25));
    
    d = smoothstep(.0, d, .5);
    //d = 1. - d;
    
    col = vec3(d);
    
    col.rg *= m;

    // Output to screen
    fragColor = vec4(col,1.0);
}

void main( void ){vec4 color = vec4(0.0,0.0,0.0,1.0); mainImage(color, gl_FragCoord.xy);color.w = 1.0;FragColor = color;}
