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


// --- access to the image of ascii code c. from https://www.shadertoy.com/view/ltcXzs
vec4 char_function(vec2 p, float c) {
    if (p.x<0.|| p.x>1. || p.y<0.|| p.y>1.) return vec4(0,0,0,1e5);
	return texture( iChannel0, p/16. + fract( floor(vec2(c, 15.999-c/16.)) / 16. ) );
}

// --- improved distance field to  ascii code c.
#if 1 // Fab way
float charD(vec2 p, float c) {
    if (p.x<0.|| p.x>1. || p.y<0.|| p.y>1.) return 0.;
    p *= 64.;
	vec4 t = texture( iChannel0, (.5+floor(p))/1024. + fract( floor(vec2(c, 15.999-c/16.)) / 16. ) );
	return t.a + dot( (fract(vec2(p.x,.999-p.y))-.5)/64., 2.*t.yz-1. );
}
#else // IQ way
float charD(vec2 p, float c) {
    if (p.x<0.|| p.x>1. || p.y<0.|| p.y>1.) return 0.;
    vec4 t = texture( iChannel0, p/16. + fract( floor(vec2(c, 15.999-c/16.)) / 16. ) );
    t.a -= 0.5;
    if( t.a > 1./255. ) t.a /= (length(2.*t.yz - 1.));
    return t.a + .5;
}
#endif

void mainImage( out vec4 c, vec2 p )
{
    p /= iResolution.y;
    
                  c += 4.*(char_function (p-vec2(-.2,0),65.).a-.4) -c;
     if (p.x>.6)  c += 4.*(charD(p-vec2( .4,0),65.)  -.4) -c;
     if (p.x>1.2) c += .5 + 300.*(charD(p-vec2(1,0),65.)-char_function(p-vec2(1,0),65.).a) -c;
    
    if (p.x<1.2) {
        float l = smoothstep(.01,0., abs(c.x-.5)),
              v = sin(30.*(c.x-.5));
        c.r += l;
        if (l==0.) c.g +=  .3* smoothstep(fwidth(v),0., abs(v));
    }
/*    
    c = char_function(p-vec2(-.2,0),65.).xxxx;
  //c += smoothstep(-.1,.1,char_function(p-vec2(-.2,0),65.).x-.5) -c;  
    c += smoothstep(.01,.0,char_function(p-vec2(.3,0),65.).a-.49);  
 // c += .5+1000.* (charD(p-vec2(.9,0),65.) -char_function(p-vec2(.9,0),65.).a); return;
 // if (p.x>1.1) c += sin(300.*char_function(p-vec2(.9,0),65.).a);
    if (p.x>1.1) c += 3.*sin(1.*charD(p-vec2(.9,0),65.))-1.;
*/
}

void main( void ){vec4 color = vec4(0.0,0.0,0.0,1.0); mainImage(color, gl_FragCoord.xy);color.w = 1.0;FragColor = color;}
