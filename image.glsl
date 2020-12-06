uniform sampler2D iChannel0;
uniform sampler2D iChannel1;
uniform vec4 iMouse;
uniform vec2 iResolution;
uniform float iTime;

//uv,circle pos , circle radius,circle edge feather
float circle(vec2 uv,vec2 pos,float radius,float feather)
{
    vec2 uvDist=uv-pos;
    return 1.0-smoothstep(radius-feather,radius+feather, length(uvDist));
}

float sdCircle( vec2 p, float r )
{
  return length(p) - r;
}

void main(void)
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = gl_FragCoord.xy/iResolution.y;

    // Time varying pixel color
    vec3 col = 0.5 + 0.5*cos(iTime+uv.xyx+vec3(0,2,4));
	col+=circle(uv,vec2(0.5,0.5),0.2,0.002);
    
    col*=vec3(sdCircle( uv-vec2(0.7,0.8), 0.1 ));
    // Output to screen
    gl_FragColor = vec4(col,1.0);
}