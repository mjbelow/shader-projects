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
        
    // if (tex1.r < .5 && tex1.g < .5 && tex1.b < .5)
        // gl_FragColor = screen(tex0, color);
    // else
    
    float b = .5;
    
    if (abs(mod(iTime/2+uv.x, b*2) - b) < uv.y)
        gl_FragColor = vec4(.5);
    else
        gl_FragColor = vec4(0.2);

    int v = mod(gl_FragCoord.x, iResolution.x/pow(2,4));
    int h = mod(gl_FragCoord.y, iResolution.y/pow(2,4));
       
    if((v > 0 && v < 2) || (h > 0 && h < 2))
        gl_FragColor = vec4(1);
        
    if (sin(iTime+gl_FragCoord.x/iResolution.x*3.14*2) * .5 + .5 > uv.y*3.14)
        gl_FragColor = multiply(vec4(1,0,0,1), gl_FragColor);
        
}