uniform sampler2D iChannel0;
uniform sampler2D iChannel1;
uniform vec4 iMouse;
uniform vec2 iResolution;
uniform float iTime;

float customRound(float f, float c)
{
    return floor(f / c) * c;
}

vec2 customRound(vec2 f, float c)
{
    return vec2(customRound(f.x, c), customRound(f.y, c));
}

void main(void)
{
    /*
    // Normalized pixel coordinates (from 0 to 1)
    
    vec2 coord = gl_FragCoord.xy;
    
    if (int(gl_FragCoord.y) % 100 < 50)
        coord.x += sin(iTime*2.)*20.0;
    else
    	coord.x += sin(iTime*2.+.2)*20.0;
    
    vec2 uv = (coord)/iResolution.xy;

    //if(((int)iResolution.y) % 6 == 0)
        //uv /= 3.;
    
    //uv.x += 36.;
    
    //int d = int(gl_FragCoord.y);
    //if (d % 6 == 0)
        //uv /= 4.;
    
    // sample texture and output to screen
    gl_FragColor = texture2D(iChannel0, uv);
    */
    bool water = false;
    vec2 uv = (gl_FragCoord.xy*2.-iResolution.xy) / iResolution.y;
    uv.y *= -1.;
    uv = vec2(length(uv)/2,atan(uv.y, uv.x)/pow(3.1415,2)-iTime);//carthesian to polar:
    vec2 uv2 = customRound(uv, .01);
    vec2 uv3 = uv;
    // uv3.y += iTime/30.*-1;
    
    // if (uv.x > .4 && uv.x < .6)
    {
    	uv2.x += 0.02*cos(-iTime*4.+uv2.y*64.);
    	uv3.x += 0.02*cos(-iTime*4.)*20.;
        water = true;
    }
    
    gl_FragColor = texture2D(iChannel0,uv);
    
    if(uv3.x > .4 && uv3.x < .6)
    {
        gl_FragColor = texture2D(iChannel0, uv3);
        gl_FragColor = texture2D(iChannel0, uv2);
        gl_FragColor.rg *= vec2(.25,.5);
    }
}