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


float Line(vec2 p, vec2 a, vec2 b) {
    float d = DistLine(p, a, b);
    float m = S(.003, .001, d);
    m = s(d, .003);
    return m;
}

void main(void)
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = (gl_FragCoord.xy - .5 * iResolution.xy) / iResolution.y;
    //vec2 uv = gl_FragCoord.xy/iResolution.xy;
    
    vec2 a = vec2(0,0);
    vec2 b = vec2(.5, 0);
    vec2 c = vec2(.5, .5);
    
    float l1 = Line(uv, a, b);
    float l2 = Line(uv, b, c);
    float l3 = Line(uv, c, a);


    // Time varying pixel color
    vec3 col = vec3(l1) + vec3(l2) + vec3(l3);

    // Output to screen
    gl_FragColor = vec4(col,1.0);
}