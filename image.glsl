uniform sampler2D iChannel0;
uniform sampler2D iChannel1;
uniform vec4 iMouse;
uniform vec2 iResolution;
uniform float iTime;

float cr(float a, float b)
{
    //return a;
    return floor(a / b) * b;
}

void main(void)
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = (gl_FragCoord.xy)/iResolution.xy;

    uv.x = (gl_FragCoord.x - iResolution.x*.5) / iResolution.x;
    uv.y = (gl_FragCoord.y) / iResolution.y;
    
    //uv.y = uv.y - 1.;
    
    //uv = vec2(length(uv), atan(uv.x,uv.y));
    
    // Time varying pixel color
    vec3 col = 0.5 + 0.5*cos(iTime+cr(atan(uv.y, uv.x),.2)+vec3(0,2,4));

    mat3 avg;
    avg[0] = vec3(.393, .769, .189);
    avg[1] = vec3(.349, .686, .168);
    avg[2] = vec3(.272, .534, .131);
    
    
    //col *= avg;
    
    // Output to screen
    gl_FragColor = vec4(col,1.0);
}