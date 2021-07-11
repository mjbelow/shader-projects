#version 150
out vec4 FragColor;

uniform sampler2D iChannel0;
uniform sampler2D iChannel1;
uniform sampler2D iChannel2;
uniform sampler2D iChannel3;
uniform samplerCube iChannel4;
uniform samplerCube iChannel5;
uniform samplerCube iChannel6;
uniform samplerCube iChannel7;
uniform vec4 iMouse;
uniform vec2 iResolution;
uniform float iTime;


#define PI acos(-1.)
#define PI2 PI * 2.
#define E 2.71828182845904523536028

/**
 * Rotation matrix around the X axis.
 */
mat3 rotateX(float theta) {
    float c = cos(theta);
    float s = sin(theta);
    return mat3(
        vec3(1, 0, 0),
        vec3(0, c, -s),
        vec3(0, s, c)
    );
}

/**
 * Rotation matrix around the Y axis.
 */
mat3 rotateY(float theta) {
    float c = cos(theta);
    float s = sin(theta);
    return mat3(
        vec3(c, 0, s),
        vec3(0, 1, 0),
        vec3(-s, 0, c)
    );
}

/**
 * Rotation matrix around the Z axis.
 */
mat3 rotateZ(float theta) {
    float c = cos(theta);
    float s = sin(theta);
    return mat3(
        vec3(c, -s, 0),
        vec3(s, c, 0),
        vec3(0, 0, 1)
    );
}

/**
 * Constructive solid geometry intersection operation on SDF-calculated distances.
 */
float intersectSDF(float distA, float distB) {
    return max(distA, distB);
}

/**
 * Constructive solid geometry union operation on SDF-calculated distances.
 */
float unionSDF(float distA, float distB) {
    return min(distA, distB);
}

/**
 * Constructive solid geometry difference operation on SDF-calculated distances.
 */
float differenceSDF(float distA, float distB) {
    return max(distA, -distB);
}

/**
 * Return the normalized direction to march in from the eye point for a single pixel.
 *
 * fieldOfView: vertical field of view in degrees
 * size: resolution of the output image
 * fragCoord: the x,y coordinate of the pixel in the output image
 */
vec3 rayDirection(float fieldOfView, vec2 size, vec2 fragCoord) {
    vec2 xy = fragCoord - size / 2.0;
    float z = size.y / tan(radians(fieldOfView) / 2.0);
    return normalize(vec3(xy, -z));
}

/**
 * Return a transform matrix that will transform a ray from view space
 * to world coordinates, given the eye point, the camera target, and an up vector.
 *
 * This assumes that the center of the camera is aligned with the negative z axis in
 * view space when calculating the ray marching direction. See rayDirection.
 */
mat3 viewMatrix(vec3 eye, vec3 center, vec3 up) {
    // Based on gluLookAt man page
    vec3 f = normalize(center - eye);
    vec3 s = normalize(cross(f, up));
    vec3 u = cross(s, f);
    return mat3(s, u, -f);
}

//Multiply
vec4 multiply(vec4 a, vec4 b){
    return a * b;
}

//Screen
vec4 screen(vec4 a, vec4 b){
    return 1 - ( (1 - a) * (1 - b) );
}

//Color Burn
vec4 colorBurn (vec4 target, vec4 blend){
    return 1.0 - (1.0 - target)/ blend;
}

//Linear Burn
vec4 linearBurn (vec4 target, vec4 blend){
    return target + blend - 1.0;
}

//Color Dodge
vec4 colorDodge (vec4 target, vec4 blend){
    return target / (1.0 - blend);
}

//Linear Dodge
vec4 linearDodge (vec4 target, vec4 blend){
    return target + blend;
}

//Overlay
vec4 overlay (vec4 target, vec4 blend){
    vec4 temp;
    temp.x = (target.x > 0.5) ? (1.0-(1.0-2.0*(target.x-0.5))*(1.0-blend.x)) : (2.0*target.x)*blend.x;
    temp.y = (target.y > 0.5) ? (1.0-(1.0-2.0*(target.y-0.5))*(1.0-blend.y)) : (2.0*target.y)*blend.y;
    temp.z = (target.z > 0.5) ? (1.0-(1.0-2.0*(target.z-0.5))*(1.0-blend.z)) : (2.0*target.z)*blend.z;
    return temp;
}

//Soft Light
vec4 softLight (vec4 target, vec4 blend){
 vec4 temp;
    temp.x = (blend.x > 0.5) ? (1.0-(1.0-target.x)*(1.0-(blend.x-0.5))) : (target.x * (blend.x + 0.5));
    temp.y = (blend.y > 0.5) ? (1.0-(1.0-target.y)*(1.0-(blend.y-0.5))) : (target.y * (blend.y + 0.5));
    temp.z = (blend.z > 0.5) ? (1.0-(1.0-target.z)*(1.0-(blend.z-0.5))) : (target.z * (blend.z + 0.5));
    return temp;
}

//Hard Light
vec4 hardLight (vec4 target, vec4 blend){
    vec4 temp;
    temp.x = (blend.x > 0.5) ? (1.0-(1.0-target.x)*(1.0-2.0*(blend.x-0.5))) : (target.x * (2.0*blend.x));
    temp.y = (blend.y > 0.5) ? (1.0-(1.0-target.y)*(1.0-2.0*(blend.y-0.5))) : (target.y * (2.0*blend.y));
    temp.z = (blend.z > 0.5) ? (1.0-(1.0-target.z)*(1.0-2.0*(blend.z-0.5))) : (target.z * (2.0*blend.z));
    return temp;
}

//Vivid Light
vec4 vividLight (vec4 target, vec4 blend){
    vec4 temp;
    temp.x = (blend.x > 0.5) ? (1.0-(1.0-target.x)/(2.0*(blend.x-0.5))) : (target.x / (1.0-2.0*blend.x));
    temp.y = (blend.y > 0.5) ? (1.0-(1.0-target.y)/(2.0*(blend.y-0.5))) : (target.y / (1.0-2.0*blend.y));
    temp.z = (blend.z > 0.5) ? (1.0-(1.0-target.z)/(2.0*(blend.z-0.5))) : (target.z / (1.0-2.0*blend.z));
    return temp;
}

//Linear Light
vec4 linearLight (vec4 target, vec4 blend){
    vec4 temp;
    temp.x = (blend.x > 0.5) ? (target.x)+(2.0*(blend.x-0.5)) : (target.x +(2.0*blend.x-1.0));
    temp.y = (blend.y > 0.5) ? (target.y)+(2.0*(blend.y-0.5)) : (target.y +(2.0*blend.y-1.0));
    temp.z = (blend.z > 0.5) ? (target.z)+(2.0*(blend.z-0.5)) : (target.z +(2.0*blend.z-1.0));
    return temp;
}

//Pin Light
vec4 pinLight (vec4 target, vec4 blend){
    vec4 temp;
    temp.x = (blend.x > 0.5) ? (max (target.x, 2.0*(blend.x-0.5))) : (min(target.x, 2.0*blend.x));
    temp.y = (blend.y > 0.5) ? (max (target.y, 2.0*(blend.y-0.5))) : (min(target.y, 2.0*blend.y));
    temp.z = (blend.z > 0.5) ? (max (target.z, 2.0*(blend.z-0.5))) : (min(target.z, 2.0*blend.z));
    return temp;
}

float f(float x)
{
    // return sin(x);
    return pow(x,2)-pow(2,x);
}

float fi(float x)
{
    return (f(x + .1)-f(x)) / .1;
}

float fii(float x)
{
    return (fi(x + .1)-fi(x)) / .1;
}

float fiii(float x)
{
    return (fii(x + .1)-fii(x)) / .1;
}

#define epsilon .001
#define spacing 32.
#define width 1.
#define PI acos(-1.)

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (2.*fragCoord-iResolution.xy) / iResolution.xy;
    
    // uv = 10*uv;
    uv = PI*uv;
    uv.x *= 2.;
    // uv.x *= 2.;
    // uv.y 
    // uv*=2.;
    // uv.x -= PI;
    // uv.y *= -1.;
    
    
    float d = f(uv.x);
    
    fragColor = vec4(.25);
    // use step(1., f) instead of round(f) for width to work as expected
    // not using round also doesn't require clamp
    float h = step(1., mod(fragCoord.x/width,spacing/width));
    // h = clamp(h,0.,1.);
    float v = step(1., mod(fragCoord.y/width,spacing/width));
    // v = clamp(v,0.,1.);
    
    fragColor *= h*v;
    
    // if (h == v)
        // fragColor = vec4(.5);
    
    fragCoord.y = (iResolution.y - fragCoord.y) * -1.;
    
    float grid = step(1.,mod(fragCoord.y/width,spacing/width)) * step(1.,mod(fragCoord.x/width,spacing/width));
    float grid2 = step(1.,mod(fragCoord.y/width+1.,spacing/width)) * step(1.,mod(fragCoord.x/width-1.,spacing/width));
    fragColor = vec4(.25) * vec4(grid);
    if(grid2 < 1.)
        fragColor = screen(fragColor, vec4(.25));
    
    if (d > (uv.y - .05) && d < (uv.y + .05))
        fragColor = vec4(1,.5,0,1);
        // fragColor = screen(fragColor, vec4(1,.5,0,1));
}

void main( void ){vec4 color = vec4(0.0,0.0,0.0,1.0); mainImage(color, gl_FragCoord.xy);color.w = 1.0;FragColor = color;}
