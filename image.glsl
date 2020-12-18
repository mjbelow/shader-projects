uniform sampler2D iChannel0;
uniform sampler2D iChannel1;
uniform vec4 iMouse;
uniform vec2 iResolution;
uniform float iTime;

#define S(a, b, d) smoothstep(a, b, d)
#define s(d, a) step(d, a)

float DistLine(vec2 p, vec2 a, vec2 b)
{
 	vec2 pa = p-a;
    vec2 ba = b-a;
    float t = clamp(dot(pa,ba)/dot(ba,ba), 0., 1.);
    
    return length(pa - ba * t);
}


float inverse_smoothstep( float x )
{
    return 0.5 - sin(asin(1.0-2.0*x)/3.0);
}

float Line(vec2 p, vec2 a, vec2 b) {
    float d = DistLine(p, a, b);
    float m = S(.05, .004, d);
    m = s(d, .05);
    
    //m = inverse_smoothstep(m);
    return clamp(m, 0.0, 1.0);
}

void main(void)
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = (gl_FragCoord.xy - .5 * iResolution.xy) / iResolution.y;
    //vec2 uv = gl_FragCoord.xy/iResolution.xy;
    
    vec2 a = vec2(-.5,0);
    vec2 b = vec2(.0, 0);
    vec2 c = vec2(.0, .5);
    
    float l1 = Line(uv, a, b);
    float l2 = Line(uv, b, c);
    float l3 = Line(uv, c, a);


    vec3 col;
    
    // Time varying pixel color
    if (l1 >= .01 || l2 >= .02 || l3 == 1.)
    	col = vec3(.5*.5+cos(vec3(iTime) + vec3(0,2,4)));
    else
        col = vec3(0);

    // Output to screen
    gl_FragColor = vec4(col,1.0);
}