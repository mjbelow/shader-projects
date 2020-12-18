uniform sampler2D iChannel0;
uniform sampler2D iChannel1;
uniform vec4 iMouse;
uniform vec2 iResolution;
uniform float iTime;

#define S(a, b, d) smoothstep(a, b, d)
#define s(d, a) step(d, a)


float customRound(float f, float c)
{
    return floor(f / c) * c;
}

vec2 customRound(vec2 f, float c)
{
    return vec2(customRound(f.x, c), customRound(f.y, c));
}

float DistLine(vec2 p, vec2 a, vec2 b)
{
 	vec2 pa = p-a;
    vec2 ba = b-a;
    float t = clamp(dot(pa,ba)/dot(ba,ba), 0., 1.);
    
    return length(pa - ba * t);
}

// inverse of y = x²(3-2x)
float inverse_smoothstep( float x )
{
    x = 0.5 - sin(asin(1.0-2.0*x)/3.0);
    
    x = customRound(x, .1);
    return x;
}


float my_smoothstep2( float a,  float x )
{
    if (x < a)
        return 0.;
    else
        return 1.;
    //return clamp(x, 0., 1.);
    //return max(0., min(1., (x-a)/(b-a)));
}

float my_smoothstep2( float a, float b, float x )
{
    //return clamp(x, 0., 1.);
    x = max(0., min(1., (x-a)/(b-a)));
    
    x = customRound(x, .1);
    
    return x;
}

// y = x²(3-2x)
float my_smoothstep( float a, float b, float x )
{
    x = my_smoothstep2(a, b, x);
    //x = x*x*(3.0-2.0*x);
    
    x = customRound(x, .1);
    
    return x;
}



float Line(vec2 p, vec2 a, vec2 b) {
    float d = DistLine(p, a, b);
    float m = my_smoothstep2( 0.,1., d);
    //m = S(1.,0.,d);
    //m = s(.2,d);
    
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
    
    float l1 = Line(uv, a, a);
    float l2 = Line(uv, b, c);
    float l3 = Line(uv, c, a);


    //vec3 col = vec3(l1 + l2 + l3);
    vec3 col = vec3(l1);
    //if (l1 == 1.)
        //col = vec3(1);
    
    // Time varying pixel color
    /*
    if (l1 >= .01 || l2 >= .02 || l3 == 1.)
    	col = vec3(.5+.5*cos(iTime + vec3(0,2,4)));
    else
        col = vec3(0);
*/

    // Output to screen
    gl_FragColor = vec4(col,1.0);
}