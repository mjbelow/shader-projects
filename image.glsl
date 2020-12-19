uniform sampler2D iChannel0;
uniform sampler2D iChannel1;
uniform vec4 iMouse;
uniform vec2 iResolution;
uniform float iTime;

//Shader License: CC BY 3.0
//Author: Jan Mróz (jaszunio15)

#define POINT_SIZE 3.0
#define PI 3.1419

#define S(a, b, d) smoothstep(a, b, d)
#define s(d, a) step(d, a)

vec4 grid(vec2 uv)
{
    float pixelSize = fwidth(uv.x);
    
    //OX and OY
    vec4 mainAxes = vec4(0.5, 1.0, 0.5, 0.0) * smoothstep(pixelSize * 3.0, 0.0, abs(uv.x)) 
        + vec4(1.0, 0.5, 0.5, 0.0) * smoothstep(pixelSize * 3.0, 0.0, abs(uv.y));
    
    uv = fract(uv + 0.5) - 0.5;
    
    //applying grid
    vec4 result = vec4(0.5, 1.0, 0.5, 0.0) * smoothstep(pixelSize * 2.0, 0.0, abs(uv.x)) 
        + vec4(1.0, 0.5, 0.5, 0.0) * smoothstep(pixelSize * 2.0, 0.0, abs(uv.y))
        + mainAxes;
    
    return result * 0.5;
}

float DistLine(vec2 p, vec2 a, vec2 b)
{
 	vec2 pa = p-a;
    vec2 ba = b-a;
    float t = clamp(dot(pa,ba)/dot(ba,ba), 0., 1.);
    // t = dot(pa, ba)/dot(ba,ba);
    
    return length(pa - ba * t);
}


float Line(vec2 p, vec2 a, vec2 b) {
    float d = DistLine(p, a, b);
    float m = S(.03, .01, d);
    m = s(d, .03);
    return m;
}

//Triangle 2D SDF from iq shader:
//https://www.shadertoy.com/view/XsXSz4
float sdTriangle( in vec2 p, in vec2 p0, in vec2 p1, in vec2 p2 )
{
	vec2 e0 = p1 - p0;
	vec2 e1 = p2 - p1;
	vec2 e2 = p0 - p2;

	vec2 v0 = p - p0;
	vec2 v1 = p - p1;
	vec2 v2 = p - p2;

	vec2 pq0 = v0 - e0*clamp( dot(v0,e0)/dot(e0,e0), 0.0, 1.0 );
	vec2 pq1 = v1 - e1*clamp( dot(v1,e1)/dot(e1,e1), 0.0, 1.0 );
	vec2 pq2 = v2 - e2*clamp( dot(v2,e2)/dot(e2,e2), 0.0, 1.0 );
    
    float s = sign( e0.x*e2.y - e0.y*e2.x );
    vec2 d = min( min( vec2( dot( pq0, pq0 ), s*(v0.x*e0.y-v0.y*e0.x) ),
                       vec2( dot( pq1, pq1 ), s*(v1.x*e1.y-v1.y*e1.x) )),
                       vec2( dot( pq2, pq2 ), s*(v2.x*e2.y-v2.y*e2.x) ));

	return -sqrt(d.x)*sign(d.y);
}

//creating scaling transformation matrix
mat3 scaleMat(float scaleX, float scaleY)
{
	mat3 M;
    M[0] = vec3(scaleX, 0.0, 0.0);
    M[1] = vec3(0.0, scaleY, 0.0);
    M[2] = vec3(0.0, 0.0, 1.0);
    
    return M;
}

//creating rotating transformation matrix
mat3 rotationMat(float angle)
{
    angle = angle / 180.0 * PI;
        
 	mat3 M;
    M[0] = vec3(cos(angle), sin(angle), 0.0);
    M[1] = vec3(-sin(angle), cos(angle), 0.0);
    M[2] = vec3(0.0, 0.0, 1.0);
    
    return M;
} 

//creating offset transformation matrix
mat3 moveMat(float offsetX, float offsetY)
{
 	mat3 M;
    M[0] = vec3(1.0, 0.0, 0.0);
    M[1] = vec3(0.0, 1.0, 0.0);
    M[2] = vec3(offsetX, offsetY, 1.0);
    
    return M;
}  

float drawPoint(vec2 uv, vec3 point, mat3 transform)
{
    float pixelSize = fwidth(uv.x);
    
    //apply transformation to the point
    point = transform * point;
    
    return smoothstep(POINT_SIZE * pixelSize, 
                      POINT_SIZE * pixelSize - pixelSize * 2.0, 
                      distance(uv, point.xy));
}

float drawTriangle(vec2 uv, vec3 vert1, vec3 vert2, vec3 vert3, mat3 transform)
{
    
    //apply matrix transformation to all triangle vertices
    vert1 = transform * vert1;
    vert2 = transform * vert2;
    vert3 = transform * vert3;
    
    
    
    float l1 = Line(uv, vert1.xy, vert2.xy);
    float l2 = Line(uv, vert2.xy, vert3.xy);
    float l3 = Line(uv, vert3.xy, vert1.xy);
    return l1 + l2 + l3;
}

void main(void)
{
    vec3 uv = vec3((gl_FragCoord.xy * 2.0 - iResolution.xy) / iResolution.y, 1.0);
    
    //uv scale
    uv *= 5.0;

    //triangle vertices
    vec3 vert1 = vec3(0.0, 0.0, 1.0);
    vec3 vert2 = vec3(2.0, 0.0, 1.0);
    vec3 vert3 = vec3(0.0, 2.0, 1.0);
    
    //triangle transformation
    mat3 transformation = 
        rotationMat(iTime * 10.0) *
        moveMat(2.0, 0.0) * 
        rotationMat(iTime * 100.0) *
        scaleMat(1.0, 1.2) *
        moveMat(-2.0, 0.0);
    
    //drawing a triangle
    float triangle = drawTriangle(uv.xy, vert1, vert2, vert3, transformation);
    
    //placing a rotating point as a child of the triangle
    mat3 pointTransformation = 
        transformation * 
        rotationMat(-iTime * 300.0);
    
    //drawing the point as a child of the triangle
    vec3 pointCenter = vec3(0.5, 0.0, 1.0);
    float point = drawPoint(uv.xy, pointCenter, pointTransformation);
    
    //display the triangle and the point with uv grid
    gl_FragColor = mix(grid(uv.xy), vec4(1.0), triangle);
    gl_FragColor = mix(gl_FragColor, vec4(0.0, 1.0, 1.0, 0.0), point);
}