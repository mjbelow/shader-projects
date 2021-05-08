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


void translate(inout mat4 m, in vec3 d){
	m[3][0] = d.x;
    m[3][1] = d.y;
    m[3][2] = d.z;
}

void scale(inout mat4 m, in vec3 s){
	m[0][0] = s.x;
    m[1][1] = s.y;
    m[2][2] = s.z;
}

mat4 lookAt(vec3 pos, vec3 target, vec3 up){
    vec3 d = target - pos;
    vec3 z = normalize(-d);
    vec3 x = cross(up, z);
    vec3 y = cross(z, x);
    
    mat4 m = mat4(1.0);
    
    m[0][0] = x.x;
    m[1][0] = x.y;
    m[2][0] = x.z;
    m[3][0] = d.x;
    
    
    m[0][1] = y.x;
    m[1][1] = y.y;
    m[2][1] = y.z;
    m[3][1] = d.y;
    
    m[0][2] = z.x;
    m[1][2] = z.y;
    m[2][2] = z.z;
    m[3][2] = d.z;
    
    return m;
}

mat4 perspective(float fov, float n, float f, float aspect){
 	float a = aspect;
    float thf = tan(fov/2.0);
    
    mat4 m = mat4(0);
    
    m[0][0] = 1.0 / (a * thf);
	m[1][1] = 1.0 / (thf);
	m[2][2] = - (f + n) / (f - n);
	m[2][3] = - 1.0;
	m[3][2] = - (2.0 * f * n) / (f - n);
    
    return m;
}

mat4 rasterToScreen(vec2 raster){
    mat4 m = mat4(1.);
    translate(m, vec3(-1.0, -1.0, 0.0));
    scale(m, vec3(2.0 / raster.x, 2.0/raster.y, 1.0));
    
	return m; 
}

void swap(inout float a, inout float b){
    float temp = a;
    a = b;
    b = temp; 
}


float rng(float seed){
 	return fract(sin(seed) * 43758.54531230);   
}

#define PI 3.1415926535897932384626433832795

struct Camera{
	mat4 cameraToWorld;
	mat4 cameraToScreen;
	mat4 rasterToCamera;
	mat4 screenToRaster;
	mat4 rasterToScreen;
};    
    

struct Ray{
	vec3 o;
    vec3 d;
    float tMax;
};
    
struct Sphere{
	vec3 c;
    float r;
};
    
struct Box{
    vec3 min;
    vec3 max;
};
    
struct Plane{
  vec3 n;
  float d;
};


    
void initCamera(in mat4 view, out Camera cam){
    float a = iResolution.x/iResolution.y;
    mat4 projection = perspective(PI/3.0, 1.0, 1000.0, a);
	cam.rasterToScreen = rasterToScreen(iResolution.xy);
	cam.screenToRaster = inverse(cam.rasterToCamera);
	cam.cameraToScreen =  projection;
	cam.rasterToCamera = inverse(projection) * cam.rasterToScreen;
	cam.cameraToWorld =  inverse(view);
}

void initRay(in Camera cam, out Ray ray, vec2 pos){
    float a = iResolution.x/iResolution.y;
   
    vec3 p = (cam.rasterToCamera * vec4(pos, 0, 1)).xyz;
	ray.o = vec3(0);
	ray.d = normalize(p);
	ray.tMax = 1000.0;
    
    
    ray.o = (cam.cameraToWorld * vec4(ray.o, 1)).xyz;
	ray.d = mat3(cam.cameraToWorld) * ray.d;
	ray.d = normalize(ray.d);
    
}
 

bool intersectsPlane(Ray ray, Plane p, out float t){
    t = p.d - dot(p.n, ray.o)/dot(p.n, ray.d);
    
    return t > 0.0 && t < ray.tMax;
}

bool intersectsSphere(Ray ray, Sphere s, out float t){
    
    vec3 m = ray.o - s.c;
    float a = dot(ray.d, ray.d);
    float b = dot(m, ray.d);
    float c = dot(m, m) - s.r * s.r;
    
    float discr = b * b - a * c;
    if(discr < 0.0) return false;
    
    float sqrtDiscr = sqrt(discr);

	float t0 = (-b - sqrtDiscr) / a;
	float t1 = (-b + sqrtDiscr) / a;
	if (t0 > t1) swap(t0, t1);
    t = t0;
    return t > 0. && t < ray.tMax;
}

bool intersectBox(Ray ray, Box b, out float t){
    vec3 tmin = (b.min - ray.o)/ray.d;
    vec3 tMax = (b.max - ray.o)/ray.d;
   
    vec3 t0 = min(tmin, tMax);
    vec3 t1 = max(tmin, tMax);
    
    float tNear = max(t0.x, max(t0.y, t0.z));
    float tFar = min(t1.x, max(t1.y, t1.z));
    
    if(tNear > ray.tMax) return false;
    
    t = tNear;
    return tNear < tFar;
}

vec3 shade(Ray ray, float t, Sphere s, vec3 lPos, vec3 mat){
    vec3 p = ray.o + ray.d * t;
    vec3 n = normalize(p - s.c);
    vec3 l = lPos - p;
    return max(0., dot(n, l)) * vec3(1) * mat;
}


float sinc( float x, float k )
{
    float a = PI * (k*x-1.0);
    return sin(a)/a;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    
    Camera cam;
    Ray ray;
    mat4 view = lookAt(vec3(0, 0, 5), vec3(0), vec3(0, 1, 0));
    
    initCamera(view, cam);
    initRay(cam, ray, fragCoord);
    
    Plane p;
    p.n = vec3(0, 1, 0);
    p.d = -3.0;
    
    vec3 color = vec3(0);
    
    float t;
    Sphere s;
    
    s.c = vec3(0);
    s.r = 1.0;
    
    Sphere light;
    light.c = vec3(1.2, 1.2, 0);
    light.r = 0.1; 
    light.c.x = cos(iTime);
    light.c.z = 3. * sin(iTime);
    
    Box b;
    b.min = vec3(-1.2, -1.2, 0);
    b.max = vec3(1.2, 1.2, 0);
    
    if(intersectsSphere(ray, light, t)){
     	color = vec3(1);   
    }
        
    if(intersectsSphere(ray, s, t)){
        vec3 mat = vec3(1, 0, 0);
        color = shade(ray, t, s, light.c, mat);
    }
    
 //   if(intersectBox(ray, b, t)){
 //    	vec3 mat = vec3(0, 1, 0);
 //       color = mat;
 //   }
    
    if(intersectsPlane(ray, p, t)){
        color = vec3(0, 0, 1);
    }


    fragColor = vec4(color, 1);
}

void main( void ){vec4 color = vec4(0.0,0.0,0.0,1.0); mainImage(color, gl_FragCoord.xy);color.w = 1.0;FragColor = color;}
