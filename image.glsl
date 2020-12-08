#version 120
uniform sampler2D iChannel0;
uniform sampler2D iChannel1;
uniform vec4 iMouse;
uniform vec2 iResolution;
uniform float iTime;

#define PI 3.14159265358979323846264
#define  E 2.71828182845904523536028

vec4 multiply(vec4 a, vec4 b)
{
    return a * b;
}

vec4 screen(vec4 a, vec4 b)
{

    return 1 - ( (1 - a) * (1 - b) );

}

float avg(vec2 a)
{
    return (a.x+a.y)/2.;
}

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

    vec2 uv = (gl_FragCoord.xy-iResolution.xy*.5)/iResolution.y;
    vec2 uv2 = ((gl_FragCoord.xy-iResolution.xy*.5)/iResolution.xy)*10.;

    uv2 = mod(uv2, 1.);

    float cycle = PI*2.0/3.0;

    vec3 col = 0.5 + 0.5*cos(iTime-avg(uv2)+vec3(0, cycle, cycle*2.0));

    col*=smoothstep(.1,.2,vec3(sdCircle(uv2 - vec2(.5, .5),.2)));

    vec4 color = vec4(col, 1.0);

    gl_FragColor = multiply(vec4(avg(uv2)), color);
}