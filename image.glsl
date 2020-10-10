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

void main(void)
{

    vec2 uv = gl_FragCoord.xy/iResolution.xy;

    float cycle = PI*2.0/3.0;

    vec3 col = 0.5 + 0.5*cos(iTime+uv.xyx+vec3(0, cycle, cycle*2.0));

    vec4 tex0 = texture2D(iChannel0, uv);
    vec4 tex1 = texture2D(iChannel1, uv);
    vec4 color = vec4(col, 1.0);
        
    if (tex1.r < .5 && tex1.g < .5 && tex1.b < .5)
        gl_FragColor = screen(tex0, color);
    else
        gl_FragColor = multiply(tex1, color);
}