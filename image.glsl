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


#define EPSILON 0.0001
#define MAX_STEPS 500
#define MIN_DIST 0.0
#define MAX_DIST 25.0

#define AMBIENT 0.1
#define EDGE_THICKNESS 0.015
#define SHADES 4.0

float TorusSDF(vec3 samplePoint, vec2 dimensions)
{
    return length( vec2(length(samplePoint.xz)-dimensions.x,samplePoint.y) )-dimensions.y;
}

float SceneSDF(vec3 samplePoint)
{
    return TorusSDF(samplePoint, vec2(1.3, 0.45));
}

float March(vec3 origin, vec3 direction, float start, float stop, inout float edgeLength)
{
    float depth = start;

    for (int i = 0; i < MAX_STEPS; i++)
    {
        float dist = SceneSDF(origin + (depth * direction)); // Grab min step
        edgeLength = min(dist, edgeLength);

        if (dist < EPSILON) // Hit
            return depth;

        if (dist > edgeLength && edgeLength <= EDGE_THICKNESS ) // Edge hit
            return 0.0;

        depth += dist; // Step

        if (depth >= stop) // Reached max
            break;
    }

    return stop;
}

vec3 RayDirection(float fov, vec2 size, vec2 fragCoord)
{
    vec2 xy = fragCoord - (size / 2.0);
    float z = size.y / tan(radians(fov) / 2.0);
    return normalize(vec3(xy, -z));
}

vec3 EstimateNormal(vec3 point)
{
    return normalize(vec3(SceneSDF(vec3(point.x + EPSILON, point.y, point.z)) - SceneSDF(vec3(point.x - EPSILON, point.y, point.z)),
                          SceneSDF(vec3(point.x, point.y + EPSILON, point.z)) - SceneSDF(vec3(point.x, point.y - EPSILON, point.z)),
                          SceneSDF(vec3(point.x, point.y, point.z + EPSILON)) - SceneSDF(vec3(point.x, point.y, point.z - EPSILON))));
}

mat4 LookAt(vec3 camera, vec3 target, vec3 up)
{
    vec3 f = normalize(target - camera);
    vec3 s = cross(f, up);
    vec3 u = cross(s, f);

    return mat4(vec4(s, 0.0),
                vec4(u, 0.0),
                vec4(-f, 0.0),
                vec4(0.0, 0.0, 0.0, 1));
}

vec3 ComputeLighting(vec3 point, vec3 lightDir, vec3 lightColor)
{
    vec3 color = vec3(AMBIENT);
    float intensity = dot(EstimateNormal(point), normalize(lightDir));
    intensity = ceil(intensity * SHADES) / SHADES;
    intensity = max(intensity, AMBIENT);
    color = lightColor * intensity;
    return color;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec3 viewDir = RayDirection(90.0, iResolution.xy, fragCoord);
    vec3 origin = vec3(sin(iTime) * 9.0, (sin(iTime * 2.0) * 4.0) + 6.0, cos(iTime) * 9.0);
    mat4 viewTransform = LookAt(origin, vec3(0.0), vec3(0.0, 1.0, 0.0));
    viewDir = (viewTransform * vec4(viewDir, 0.0)).xyz;

    float edgeLength = MAX_DIST;
    float dist = March(origin, viewDir, MIN_DIST, MAX_DIST, edgeLength);

    vec3 p = origin + dist * viewDir;

    if (dist > MAX_DIST - EPSILON) // No hit
    {
        fragColor = texture(iChannel4, p);
        return;
    }

    if (dist < EPSILON) // Edge hit
    {
        fragColor = vec4(0.0);
        return;
    }

    vec3 hitPoint = origin + (dist * viewDir);
    vec3 lightDir = vec3(sin(iTime * 2.0) * 6.0, 4.0, sin(iTime * 1.25) * 5.0);
    vec3 color = vec3(1.0, 0.5, 0.1);

    color = texture(iChannel4, p).rgb;
    color = ComputeLighting(hitPoint, lightDir, color);

    fragColor = vec4(color, 1.0);
}

void main( void ){vec4 color = vec4(0.0,0.0,0.0,1.0); mainImage(color, gl_FragCoord.xy);color.w = 1.0;FragColor = color;}
