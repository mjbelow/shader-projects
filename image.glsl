uniform sampler2D iChannel0;
uniform sampler2D iChannel1;
uniform vec4 iMouse;
uniform vec2 iResolution;
uniform float iTime;

#define PI 3.14159265359
#define TWO_PI 6.28318530718

void main(void)
{
    vec2 uv = gl_FragCoord.xy / iResolution.xy;
    vec2 center = 2.0 * vec2(gl_FragCoord.xy - 0.5 * iResolution.xy) / iResolution.y;
    
	uv = vec2( 2.0 * gl_FragCoord.xy - iResolution.xy ) / iResolution.y;
     
    int N = 3;
    
    float a = atan(uv.x,uv.y) + PI,
          r = TWO_PI / float(N),
          d = cos(floor(0.5 + a / r) * r - a) * length(uv);

    gl_FragColor = vec4(smoothstep(0.41,0.4,d));
}
