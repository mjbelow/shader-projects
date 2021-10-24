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


const float EPSILON = 0.2;
const float PI = acos(-1.);
const float TAU = 2.0*PI;

bool stroke(float a, float b, float width)
{
    width /= 2.0;
    
    return a < b+width && a > b-width;
}

float sdfCircle(vec2 p, float r)
{
    return length(p) - r;
}

float f(float v)
{
return pow(v,3.);
}

float f_dash(float v)
{
return 3.*pow(v,2.);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    //fragCoord = iResolution.xy - fragCoord.xy;
    //fragCoord.x = iResolution.x - fragCoord.x;
    
    vec2 uv = (fragCoord*2.-iResolution.xy)/iResolution.xy*vec2(TAU*2.,TAU);
    //uv.x = (fragCoord.x*2.-1.*iResolution.x)/iResolution.x*TAU;
    //uv.y = (fragCoord.y*2.-1.*iResolution.y)/iResolution.y*TAU;

    // Time varying pixel color
    vec3 col = 0.5 + 0.5*cos(iTime+(uv.xyx/TAU)+vec3(0,2,4));

    // Output to screen
    fragColor = vec4(col,1.0);
    
    float v = sin(iTime*.5)*PI;
    
    float uv_angle = (uv.x+uv.y*f_dash(v));
    //if(sin(uv.x*TAU)*.5+.5 > uv.y)
    if(
    stroke(f(uv.x),uv.y, .2)
    ||
    (stroke(f_dash(v)*(uv.x-v)+f(v),uv.y, .1) && mod(uv_angle,1.) < .5)
    ||
    stroke(0.,uv.y, .05)
    ||
    stroke(0.,uv.x, .05)
    )
        fragColor = vec4(0);

    float d = sdfCircle(vec2(v, f(v)) - uv, 0.25);
        
    if(d < 1.)
    {
        fragColor = 1.-((d)*(1.-fragColor));
    }

    

    //if(uv_angle < .0)
        //fragColor *= vec4(1,0,0,0);
    
    //fragColor = texture(iChannel0, uv);
}

void main( void ){vec4 color = vec4(0.0,0.0,0.0,1.0); mainImage(color, gl_FragCoord.xy);color.w = 1.0;FragColor = color;}
