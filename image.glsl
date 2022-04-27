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
#define spacing 32.
#define width 1.

//Screen
vec4 screen(vec4 a, vec4 b){
    return 1 - ( (1 - a) * (1 - b) );
}

const vec3 rgb_ratio = vec3(0.333);

float gradient_map_rainbow(float f)
{
  // float f = dot(col, rgb_ratio);
  f *= 12.;
  int i = int(floor(f));
  f = fract(f);
  
  // return vec3(f);

  float color_a;
  float color_b;

  switch (i%2)
  {
  case 0:
      color_a = 1;
      color_b = 0;
      break;
  case 1:
      color_a = 0;
      color_b = 1;
      break;
  }

  return mix(color_a, color_b, f);
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

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = (fragCoord*1.-.5*iResolution.xy) / iResolution.y;
	
	// uv = fragCoord / iResolution.y;
	
	float theta = iTime*40.;
	theta = theta / 180. * PI;
	
	// uv = mat2(
	// cos(theta)*8, 0,
	// sin(theta)*8, 8
	// ) * uv;
	
float x = uv.x;
float y = uv.y;

	uv = mat2(
	1, sin(iTime + uv.x),
	0, 1
	) * uv;
	
	uv *= 16.;

    uv = mod(uv, 1.);

    fragColor = texture(iChannel0, uv);
    fragColor = vec4(1.-smoothstep(0,.5,min(uv.x, uv.y)));
}

void main( void ){vec4 color = vec4(0.0,0.0,0.0,1.0); mainImage(color, gl_FragCoord.xy);color.w = 1.0;FragColor = color;}
