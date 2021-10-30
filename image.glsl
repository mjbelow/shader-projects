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

    
    float STAGE2 = 1./2.;
    float STAGE3 = STAGE2 + 1./3.;
    float STAGE4 = STAGE3 + 1./4.;
    float STAGE5 = STAGE4 + 1./5.;
    float STAGE6 = STAGE5 + 1./6.;
 
    if(x > STAGE6)
      uv.x = x*7. - (STAGE2 + STAGE3 + STAGE4 + STAGE5 + STAGE6);
    else if(x > STAGE5)
      uv.x = x*6. - (STAGE2 + STAGE3 + STAGE4 + STAGE5);
    else if(x > STAGE4)
      uv.x = x*5. - (STAGE2 + STAGE3 + STAGE4);
    else if(x > STAGE3)
      uv.x = x*4. - (STAGE2 + STAGE3);
    else if(x > STAGE2)
    {
    // {
    // fragColor = vec4(1,0,0,1);
    // return;
      uv.x = x * 3 - STAGE2;
    }
    
    // Time varying pixel color
    //vec3 col = 0.5 + 0.5*cos(iTime+uv.xyx+vec3(0,2,4));
    
    vec3 col = vec3(0.05);
    
    
    
    

    if(stroke(uv))
    {
        col = vec3(1);
    }

    if(x > STAGE6)
    {
    col *= vec3(1,0,0);
    }
    
    // Output to screen
    fragColor = vec4(col,1.0);
}

void main( void ){vec4 color = vec4(0.0,0.0,0.0,1.0); mainImage(color, gl_FragCoord.xy);color.w = 1.0;FragColor = color;}
