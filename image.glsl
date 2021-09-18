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


//Multiply
vec4 multiply(vec4 a, vec4 b){
    return a * b;
}

//Screen
vec3 screen(vec3 a, vec3 b){
    return 1 - ( (1 - a) * (1 - b) );
}

//2D Box
float sdBox( in vec2 p, in vec2 b )
{
    vec2 d = abs(p)-b;
    return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}

//2D Circle
float sdCircle( vec2 p, float r )
{
    return length(p) - r;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    fragCoord.x = iResolution.x - fragCoord.x;

    vec2 uv = fragCoord/iResolution.xy;
    vec2 uv2 = (fragCoord*2.-iResolution.xy)/iResolution.xy;

    // Time varying pixel color
    vec3 col = 0.5 + 0.5*cos(iTime+uv.xyx+vec3(0,2,4));
    
    
    float bw = (uv.x+uv.y)/2.;
    
    vec3 col_a = vec3(1,.75,0.25);
    vec3 col_b = vec3(1,0.25,.75);
    
    col = mix(col_b,col_a,bw);
    
    
    
    float box = sdBox(uv2,vec2(.75));
    
    if (box > .25)
        col=vec3(1);
    else if (box > .24)
        col = screen(col, vec3(.5));

    // Output to screen
    fragColor = vec4(col,1.0);
}


void main( void ){vec4 color = vec4(0.0,0.0,0.0,1.0); mainImage(color, gl_FragCoord.xy);color.w = 1.0;FragColor = color;}
