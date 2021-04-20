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

vec3 multiply(vec3 a, vec3 b){
    return a * b;
}

vec4 screen(vec4 a, vec4 b){
    return 1. - ( (1. - a) * (1. - b) );
}

float hash3(vec3 p){
    return fract(sin(dot(vec3(15.0, 35.7, 58.2), p)) * 43648.23);
}

float noise3(vec3 p){
    vec3 g = floor(p);
    vec3 f = fract(p);
    f = 3.0*f*f - 2.0*f*f*f; // cubic hermite spline, 3*x^2 - 2*x^3, hermite polymonals

    float lbd = hash3(g + vec3(0.0, 0.0, 0.0));
    float rbd = hash3(g + vec3(1.0, 0.0, 0.0));
    float ltd = hash3(g + vec3(0.0, 1.0, 0.0));
    float rtd = hash3(g + vec3(1.0, 1.0, 0.0));

    float lbu = hash3(g + vec3(0.0, 0.0, 1.0));
    float rbu = hash3(g + vec3(1.0, 0.0, 1.0));
    float ltu = hash3(g + vec3(0.0, 1.0, 1.0));
    float rtu = hash3(g + vec3(1.0, 1.0, 1.0));

    float bd = mix(lbd, rbd, f.x);
    float td = mix(ltd, rtd, f.x);
    float d = mix(bd, td, f.y);

    float bu = mix(lbu, rbu, f.x);
    float tu = mix(ltu, rtu, f.x);
    float u = mix(bu, tu, f.y);

    float res = mix(d, u, f.z);

    return res;
}

/**
 * Part 6 Challenges:
 * - Make a scene of your own! Try to use the rotation transforms, the CSG primitives,
 *   and the geometric primitives. Remember you can use vector subtraction for translation,
 *   and component-wise vector multiplication for scaling.
 */

const int MAX_MARCHING_STEPS = 255;
const float MIN_DIST = 0.0;
const float MAX_DIST = 100.0;
const float EPSILON = 0.0001;

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
 * Signed distance function for a cube centered at the origin
 * with dimensions specified by size.
 */
float boxSDF(vec3 p, vec3 size) {
    vec3 d = abs(p) - (size / 2.0);

    // Assuming p is inside the cube, how far is it from the surface?
    // Result will be negative or zero.
    float insideDistance = min(max(d.x, max(d.y, d.z)), 0.0);

    // Assuming p is outside the cube, how far is it from the surface?
    // Result will be positive or zero.
    float outsideDistance = length(max(d, 0.0));

    return insideDistance + outsideDistance;
}

/**
 * Signed distance function for a sphere centered at the origin with radius r.
 */
float sphereSDF(vec3 p, float r) {
    return length(p) - r + noise3(p*15.+iTime)*.2;
}

/**
 * Signed distance function for an XY aligned cylinder centered at the origin with
 * height h and radius r.
 */
float cylinderSDF(vec3 p, float h, float r) {
    // How far inside or outside the cylinder the point is, radially
    float inOutRadius = length(p.xy) - r;

    // How far inside or outside the cylinder is, axially aligned with the cylinder
    float inOutHeight = abs(p.z) - h/2.0;

    // Assuming p is inside the cylinder, how far is it from the surface?
    // Result will be negative or zero.
    float insideDistance = min(max(inOutRadius, inOutHeight), 0.0);

    // Assuming p is outside the cylinder, how far is it from the surface?
    // Result will be positive or zero.
    float outsideDistance = length(max(vec2(inOutRadius, inOutHeight), 0.0));

    return insideDistance + outsideDistance;
}

/**
 * Signed distance function describing the scene.
 *
 * Absolute value of the return value indicates the distance to the surface.
 * Sign indicates whether the point is inside or outside the surface,
 * negative indicating inside.
 */
float sceneSDF(vec3 samplePoint) {
    // Slowly spin the whole scene
    // samplePoint = rotateY(-iTime / 2.0) * samplePoint;
    return sphereSDF(samplePoint, 2.0);


    float cylinderRadius = 0.4 + (1.0 - 0.4) * (1.0 + sin(1.7 * iTime)) / 2.0;
    float cylinder1 = cylinderSDF(samplePoint, 2.0, cylinderRadius);
    float cylinder2 = cylinderSDF(rotateX(radians(90.0)) * samplePoint, 2.0, cylinderRadius);
    float cylinder3 = cylinderSDF(rotateY(radians(90.0)) * samplePoint, 2.0, cylinderRadius);

    float cube = boxSDF(samplePoint, vec3(1.8, 1.8, 1.8));

    float sphere = sphereSDF(samplePoint, 1.2);

    float ballOffset = 0.4 + 1.0 + sin(1.7 * iTime);
    float ballRadius = 0.3;
    float balls = sphereSDF(samplePoint - vec3(ballOffset, 0.0, 0.0), ballRadius);
    balls = unionSDF(balls, sphereSDF(samplePoint + vec3(ballOffset, 0.0, 0.0), ballRadius));
    balls = unionSDF(balls, sphereSDF(samplePoint - vec3(0.0, ballOffset, 0.0), ballRadius));
    balls = unionSDF(balls, sphereSDF(samplePoint + vec3(0.0, ballOffset, 0.0), ballRadius));
    balls = unionSDF(balls, sphereSDF(samplePoint - vec3(0.0, 0.0, ballOffset), ballRadius));
    balls = unionSDF(balls, sphereSDF(samplePoint + vec3(0.0, 0.0, ballOffset), ballRadius));



    float csgNut = differenceSDF(intersectSDF(cube, sphere),
                         unionSDF(cylinder1, unionSDF(cylinder2, cylinder3)));

    return unionSDF(balls, csgNut);
}

/**
 * Return the shortest distance from the eyepoint to the scene surface along
 * the marching direction. If no part of the surface is found between start and end,
 * return end.
 *
 * eye: the eye point, acting as the origin of the ray
 * marchingDirection: the normalized direction to march in
 * start: the starting distance away from the eye
 * end: the max distance away from the ey to march before giving up
 */
float shortestDistanceToSurface(vec3 eye, vec3 marchingDirection, float start, float end) {
    float depth = start;
    for (int i = 0; i < MAX_MARCHING_STEPS; i++) {
        float dist = sceneSDF(eye + depth * marchingDirection);
        if (dist < EPSILON) {
            return depth;
        }
        depth += dist;
        if (depth >= end) {
            return end;
        }
    }
    return end;
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
 * Using the gradient of the SDF, estimate the normal on the surface at point p.
 */
vec3 estimateNormal(vec3 p) {
    return normalize(vec3(
        sceneSDF(vec3(p.x + EPSILON, p.y, p.z)) - sceneSDF(vec3(p.x - EPSILON, p.y, p.z)),
        sceneSDF(vec3(p.x, p.y + EPSILON, p.z)) - sceneSDF(vec3(p.x, p.y - EPSILON, p.z)),
        sceneSDF(vec3(p.x, p.y, p.z + EPSILON)) - sceneSDF(vec3(p.x, p.y, p.z - EPSILON))
    ));
}

/**
 * Lighting contribution of a single point light source via Phong illumination.
 *
 * The vec3 returned is the RGB color of the light's contribution.
 *
 * k_a: Ambient color
 * k_d: Diffuse color
 * k_s: Specular color
 * alpha: Shininess coefficient
 * p: position of point being lit
 * eye: the position of the camera
 * lightPos: the position of the light
 * lightIntensity: color/intensity of the light
 *
 * See https://en.wikipedia.org/wiki/Phong_reflection_model#Description
 */
vec3 phongContribForLight(vec3 k_d, vec3 k_s, float alpha, vec3 p, vec3 eye,
                          vec3 lightPos, vec3 lightIntensity) {
    vec3 N = estimateNormal(p);
    vec3 L = normalize(lightPos - p);
    vec3 V = normalize(eye - p);
    vec3 R = normalize(reflect(-L, N));

    float dotLN = dot(L, N);
    float dotRV = dot(R, V);

    if (dotLN < 0.0) {
        // Light not visible from this point on the surface
        return vec3(0.0, 0.0, 0.0);
    }

    if (dotRV < 0.0) {
        // Light reflection in opposite direction as viewer, apply only diffuse
        // component
        return lightIntensity * (k_d * dotLN);
    }
    return lightIntensity * (k_d * dotLN + k_s * pow(dotRV, alpha));
}

/**
 * Lighting via Phong illumination.
 *
 * The vec3 returned is the RGB color of that point after lighting is applied.
 * k_a: Ambient color
 * k_d: Diffuse color
 * k_s: Specular color
 * alpha: Shininess coefficient
 * p: position of point being lit
 * eye: the position of the camera
 *
 * See https://en.wikipedia.org/wiki/Phong_reflection_model#Description
 */
vec3 phongIllumination(vec3 k_a, vec3 k_d, vec3 k_s, float alpha, vec3 p, vec3 eye) {
    const vec3 ambientLight = 0.5 * vec3(1.0, 1.0, 1.0);
    vec3 color = ambientLight * k_a;

    vec3 light1Pos = vec3(4.0 * sin(iTime),
                          2.0,
                          4.0 * cos(iTime));
    vec3 light1Intensity = vec3(0.4, 0.4, 0.4);

    color += phongContribForLight(k_d, k_s, alpha, p, eye,
                                  light1Pos,
                                  light1Intensity);

    vec3 light2Pos = vec3(2.0 * sin(0.37 * iTime),
                          2.0 * cos(0.37 * iTime),
                          2.0);
    vec3 light2Intensity = vec3(0.4, 0.4, 0.4);

    color += phongContribForLight(k_d, k_s, alpha, p, eye,
                                  light2Pos,
                                  light2Intensity);
    return color;
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

#define PI acos(-1.)

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec3 viewDir = rayDirection(90.0, iResolution.xy, fragCoord);
    vec3 eye = vec3(8.0*cos(iTime/2.), 2.0 * sin(0.2 * iTime), 8.0*sin(iTime/2.));

    // Camera up vector.
    vec3 camUp=vec3(0,1,0);

    // Camera lookat.
    vec3 camLookat=vec3(0,0.0,0);

    // debugging camera
    float mx=iMouse.x/iResolution.x*PI*2.0;
    float my=iMouse.y/iResolution.y*3.14 + PI/2.0;
    eye = vec3(cos(my)*cos(mx),sin(my),cos(my)*sin(mx))*7.0;

    mat3 viewToWorld = viewMatrix(eye, camLookat,camUp);

    vec3 worldDir = viewToWorld * viewDir;
    // worldDir = ceil(worldDir*.999);
    // worldDir *= 120.;

    // worldDir = floor(worldDir);

    // worldDir /= 120.;
    // worldDir *= 8.;
    // normalize(worldDir);

    float dist = shortestDistanceToSurface(eye, worldDir, MIN_DIST, MAX_DIST);

    vec2 uv = fragCoord/iResolution.xy;
    vec2 po = (fragCoord*2.-iResolution.xy)/iResolution.xy;

    fragColor = vec4(1, uv.x, uv.y, 0);
    fragColor = mix(vec4(worldDir, 1), texture(iChannel4, worldDir), .75);
    // fragColor = screen(fragColor, texture(iChannel4, worldDir));
    fragColor = screen(vec4(worldDir, 1), texture(iChannel4, worldDir));
    // fragColor = vec4(worldDir, 1);
    fragColor = texture(iChannel4, worldDir);

    if (dist > MAX_DIST - EPSILON) {
        // Didn't hit anything
    return;
    }

    // The closest point on the surface to the eyepoint along the view ray
    vec3 p = eye + dist * worldDir;


    // Use the surface normal as the ambient color of the material
    vec3 K_a = (estimateNormal(p) + vec3(1.0)) / 2.0;
    vec3 K_d = K_a;
    vec3 K_s = vec3(1.0, 1.0, 1.0);
    float shininess = 10.0;

    vec3 color = phongIllumination(K_a, K_d, K_s, shininess, p, eye);

    color = estimateNormal(p);
    //color = vec3(dot(color, vec3(0.2125, 0.7154, 0.0721)));
    mat3 m = mat3(
    vec3(0.2125, 0.7154, 0.0721),
    vec3(0.2125, 0.7154, 0.0721),
    vec3(0.2125, 0.7154, 0.0721)
    );

    color *= m;

    fragColor = mix(fragColor, vec4(color, 1.0), .25);

    fragColor = texture(iChannel4, p);
    // fragColor = texture(iChannel4, reflect(p,vec3(1)));
    // fragColor = texture(iChannel4, reflect(vec3(1),p));
    // fragColor = texture(iChannel4, reflect(p,p));
}

void main( void ){vec4 color = vec4(0.0,0.0,0.0,1.0); mainImage(color, gl_FragCoord.xy);color.w = 1.0;FragColor = color;}
