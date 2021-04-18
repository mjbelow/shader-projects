#version 150
out vec4 FragColor;

uniform sampler2D iChannel0;
uniform sampler2D iChannel1;
uniform vec4 iMouse;
uniform vec2 iResolution;
uniform float iTime;


#define AA 0

float OpUnion( float OperandA, float OperandB)
{
	return min( OperandA, OperandB );
}

float OpSubtract( float OperandA, float OperandB)
{
	return max( OperandA, -OperandB );
}

float OPIntersection( float OperandA, float OperandB)
{
	return max( OperandA, OperandB );
}

float Floor( vec3 QueryPoint )
{
    return QueryPoint.z;
}

float Box( vec3 QueryPoint, vec3 Bounds )
{
	vec3 d = abs(QueryPoint) - (Bounds / 2.0);
	float InsideDistance = min(max(d.x, max(d.y, d.z)), 0.0);
	float OutsideDistance = length(max(d, 0.0));
	return InsideDistance + OutsideDistance;
}

float Sphere( vec3 QueryPoint, float Radius )
{
	return length(QueryPoint) - Radius;
}

vec3 Translate( vec3 Translation, vec3 Point )
{
	return (mat4(
		1.0, 0.0, 0.0, 0.0,
		0.0, 1.0, 0.0, 0.0,
		0.0, 0.0, 1.0, 0.0,
		vec4(-Translation, 1.0)
	) * vec4(Point,1.0)).xyz;
}

float QueryScene( vec3 QueryPoint, float Time )
{
	float Distance = Sphere(
		(Translate( vec3(0.0,0.0,1.0),QueryPoint)).xyz,
		1.0
	);
    Distance = OpUnion(
        Distance,
        Sphere(
            Translate(vec3(-0.0,1.3,1.6),QueryPoint),
            0.3
        )
    );
    Distance = OpUnion(
        Distance,
        Box(
            Translate(vec3(1.1,-0.7,0.5),QueryPoint),
            vec3(0.5)
        )
    );
    Distance = OpUnion( Distance, max(min(QueryPoint.y , QueryPoint.x), QueryPoint.z) );
    Distance = OpUnion(
        Distance,
        Box(
            Translate(vec3(0.0,0.0,0.0),QueryPoint),
            vec3(3.0,3.0,0.5)
        )
    );
    Distance = OpUnion(
        Distance,
        Box(
            Translate(vec3(-1.5,0.0,1.5),QueryPoint),
            vec3(0.5,3.0,3.0)
        )
    );
    Distance = OpSubtract(
        Distance,
        Box(
            Translate(vec3(-1.5,0.0,1.5),QueryPoint),
            vec3(0.56,1.0,2.0)
        )
    );
    Distance = OpUnion(
        Distance,
        Box(
            Translate(vec3(0.0,-1.5,1.5),QueryPoint),
            vec3(3.0,0.5,3.0)
        )
    );
	return Distance;
}

const int MaxSteps = 512;
const float EPSILON = 0.0001;
float MarchScene( vec3 Origin, vec3 Direction, float Time )
{
	float Distance = 0.0;
	for( int i = 0; i < MaxSteps; ++i )
	{
		float CurDistance = QueryScene(
			Origin + Direction * Distance,
			Time
		);
		if( CurDistance < EPSILON ) // Hit
		{
			return Distance;
		}
		Distance += CurDistance;
	}
	return -1.0; // Miss
}

// Estimated gradient
vec3 GradientScene( vec3 QueryPoint, float Time)
{
	const vec2 EPSILON3 = vec2(EPSILON,0);
	return normalize(
		vec3(
			QueryScene( QueryPoint + EPSILON3.xyy, Time ) - QueryScene( QueryPoint - EPSILON3.xyy, Time ),
			QueryScene( QueryPoint + EPSILON3.yxy, Time ) - QueryScene( QueryPoint - EPSILON3.yxy, Time ),
			QueryScene( QueryPoint + EPSILON3.yyx, Time ) - QueryScene( QueryPoint - EPSILON3.yyx, Time )
		)
	);
}

float SceneAmbientOcclusion( vec3 WorldPoint, vec3 Normal, float Time )
{
	float Occlusion = 0.0;
    float Scale = 1.0;
    for( int i=0; i<5; i++ )
    {
        float hr = 0.001 + 0.125*float(i)/5.0;
        vec3 OcclusionQuery =  Normal * hr + WorldPoint;
        float dd = QueryScene( OcclusionQuery, Time );
        Occlusion += -(dd-hr)*Scale;
        Scale *= 0.95;
    }
    return clamp( 1.0 - 5.0*Occlusion, 0.0, 1.0 );
}

mat4 LookAt(vec3 Eye, vec3 Center, vec3 Up)
{
	vec3 f = normalize( Center - Eye );
	vec3 s = normalize( cross( f, Up) );
	vec3 u = cross( s, f );
	return mat4(
		vec4(  s, 0.0 ),
		vec4(  u, 0.0 ),
		vec4( -f, 0.0 ),
		vec4( 0.0, 0.0, 0.0, 1.0)
	);
}

vec3 RayDirection(float fieldOfView, vec2 size, vec2 fragCoord)
{
    vec2 xy = fragCoord - size / 2.0;
    float z = size.y / tan(radians(fieldOfView) / 2.0);
    return normalize(vec3(xy, -z));
}

const vec3 HarmonicsLUT[4] = vec3[4](
        vec3(  0.754554516862612,  0.748542953903366,  0.790921515418539 ),
        vec3( -0.083856548007422,  0.092533500963210,  0.322764661032516 ),
        vec3(  0.308152705331738,  0.366796330467391,  0.466698181299906 ),
        vec3( -0.188884931542396, -0.277402551592231, -0.377844212327557 )
);

vec3 Irradiance_Harmonics(vec3 Normal) {
    return max(
          HarmonicsLUT[0]
        + HarmonicsLUT[1] * (Normal.y)
        + HarmonicsLUT[2] * (Normal.z)
        + HarmonicsLUT[3] * (Normal.x)
        , 0.0);
}

float SoftShadow( in vec3 ro, in vec3 rd, float mint, float maxt, float k )
{
    float res = 1.0;
    float ph = 1e20;
    for( float t = mint; t < maxt; )
    {
        float h = QueryScene(ro + rd*t,iTime);
        if( h < EPSILON )
            return 0.0;
        float y = h*h/(2.0*ph);
        float d = sqrt(h*h-y*y);
        res = min( res, k*d/max(0.0, t-y) );
        ph = h;
        t += h;
    }
    return res;
}

mat3 viewMatrix(vec3 eye, vec3 center, vec3 up) {
    // Based on gluLookAt man page
    vec3 f = normalize(center - eye);
    vec3 s = normalize(cross(f, up));
    vec3 u = cross(s, f);
    return mat3(s, u, -f);
}

// mat4 LookAt(vec3 Eye, vec3 Center, vec3 Up)
// {
	// vec3 f = normalize( Center - Eye );
	// vec3 s = normalize( cross( f, Up) );
	// vec3 u = cross( s, f );
	// return mat4(
		// vec4(  s, 0.0 ),
		// vec4(  u, 0.0 ),
		// vec4( -f, 0.0 ),
		// vec4( 0.0, 0.0, 0.0, 1.0)
	// );
// }

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    float x_pos = .5+.5*cos(iTime);
    float y_pos = .5+.5*sin(iTime);

	vec3 Eye = vec3( ((vec2(x_pos, y_pos)) * 2.0 - vec2(1.0)) * 12.0, 12.0 );
    // Eye = vec3(8.0, 5.0 * sin(0.2 * iTime), 7.0);
    vec3 Center = vec3( 0.0,0.0, 1.0 );
    mat3 CameraToWorld = viewMatrix(
        Eye,
        Center,
        vec3( 0.0, .0, 1.0 )  // Up
    );
    vec3 Color = vec3(0.0);
#if AA > 1
    for( int i = 0; i < AA; ++i )
    for( int j = 0; j < AA; ++j )
    {
        vec2 Offset = vec2(float(i),float(j)) / float(AA) - 0.5;
	    vec3 ViewDir = RayDirection(45.0, iResolution.xy, gl_FragCoord.xy + Offset);
#else
		vec3 ViewDir = RayDirection(45.0, iResolution.xy, gl_FragCoord.xy);
#endif

        vec3 WorldDir = (
            CameraToWorld * vec3( ViewDir)
        ).xyz;

        float Distance = MarchScene(
            Eye,
            WorldDir,
            iTime
        );
        if( Distance >= 0.0 )
        {
            vec3 WorldPoint = Eye + WorldDir * Distance;
            vec3 WorldGradient = GradientScene( WorldPoint, iTime );
            vec3 CurColor = Irradiance_Harmonics(WorldGradient);
            float CurLighting = clamp(SoftShadow(WorldPoint,normalize(vec3(0.5,0.5,1.0)),0.01,10.0,10.3),0.0,0.5);
            CurColor *= SceneAmbientOcclusion(WorldPoint,WorldGradient,iTime);
            CurColor *= CurLighting;
            Color += CurColor;
        }
#if AA > 1
    }
    Color /= float(AA*AA);
#endif
    Color = pow( Color, vec3(0.4545));
    fragColor = vec4( Color, 1.0 );
}

void main( void ){vec4 color = vec4(0.0,0.0,0.0,1.0); mainImage(color, gl_FragCoord.xy);color.w = 1.0;FragColor = color;}
