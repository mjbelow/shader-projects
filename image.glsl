uniform sampler2D iChannel0;
uniform sampler2D iChannel1;
uniform vec4 iMouse;
uniform vec2 iResolution;
uniform float iTime;

#define AA 6.0 / iResolution.y
#define SIZE 0.75

float disk(vec2 uv, vec2 center, float radius)
{
    float d = length(uv - center);
    return smoothstep(d, d + 0.01, radius);
}

float line(vec2 uv, vec2 a, vec2 b, float width)
{
    vec2 pa = uv - a;
    vec2 ba = b - a;
	float h = clamp(dot(pa,ba) / dot(ba,ba), 0.0, 1.0);	
	return 1.0 - smoothstep(-AA, AA, length(pa - ba * h) - width);
}

float cosLine(vec2 uv, float width)
{
    return smoothstep(AA, -AA, length(cos(iTime - uv.x) - uv.y) - width);
}

float sinLine(vec2 uv, float width)
{
    return smoothstep(AA, -AA, length(sin(iTime - uv.y) - uv.x) - width);
}

float circle(vec2 uv, vec2 center, float radius)
{
    return smoothstep(AA, -AA, abs(length(uv - center)-radius));
}

void main(void)
{   
    //Uvs
    vec2 uv = (2.0 * gl_FragCoord.xy - iResolution.xy) / iResolution.y / SIZE;
    
    //Cos and Sin waves power the rotation angle
    float sinx = sin(iTime);
    float cosx = cos(iTime);
    
    //Lines showing indivisual axis movements
    float lineSX = line(uv, vec2(sinx, -1.0), vec2(sinx, 1.0), 0.005);
    float lineCX = line(uv, vec2(-1.0, cosx), vec2(1.0, cosx), 0.005);
    
    //Points of interest
    vec2 pRot = vec2(sinx, cosx);
    vec2 pOrigin = vec2(0);
    float p0 = disk(uv, pOrigin, 0.04);
    float p1 = disk(uv, vec2(sinx, 0.0), 0.03);
    float p2 = disk(uv, vec2(0.0, cosx), 0.03);
    float p3 = disk(uv, pRot, 0.04);
    
    //Lazy single channel colours...
    gl_FragColor = vec4(0.1);
	gl_FragColor.x += max(lineSX, p1);
    gl_FragColor.y += max(lineCX, p2);
    float rotLine =  max(p3 + p0, line(uv, pOrigin, pRot, 0.01));
    gl_FragColor.xyz += max(rotLine, circle(uv, pOrigin, 1.0));
    gl_FragColor.xyz += cosLine(uv, 0.005) * 0.25;
    gl_FragColor.xyz += sinLine(uv, 0.005) * 0.25;
}
