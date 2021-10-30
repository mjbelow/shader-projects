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


bool stroke(vec2 uv)
{

int stages = int(uv.x)+2;
float interval = 1. / float(stages);


for(int i = 1; i < stages; i++)
{
float target = float(i) * interval;
if(target - .0025 < uv.y && uv.y < target + .0025)
return true;

}

return false;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = (fragCoord)/iResolution.y;
    
    float x = uv.x;

    uv.x = x * 2.;
    
    float f = .75;
    
    if(x > 1./2. + 1./3.)
      uv.x = x*4. - 2./2. - 1./3.;
    else if(x > (1./2.))
    {
    // {
    // fragColor = vec4(1,0,0,1);
    // return;
      uv.x = x * 3 - 1./2.;
    }
    
    // Time varying pixel color
    //vec3 col = 0.5 + 0.5*cos(iTime+uv.xyx+vec3(0,2,4));
    
    vec3 col = vec3(0);
    
    
    
    
    //for(int i = 0; i < 4; i++)
    //{
    if(stroke(uv))
    {
    //if(y % x == 0)
        col = vec3(1);
    }
    
    if(stroke(vec2(x*4.-1.-1./3., uv.y+.01)))
    {
      col = vec3(0.5,10.,0);
    }
    
    if(x > (1./2.) + (1./3.))
    {
    col *= vec3(1,0.1,0);
    }
    
    // Output to screen
    fragColor = vec4(col,1.0);
}

void main( void ){vec4 color = vec4(0.0,0.0,0.0,1.0); mainImage(color, gl_FragCoord.xy);color.w = 1.0;FragColor = color;}
