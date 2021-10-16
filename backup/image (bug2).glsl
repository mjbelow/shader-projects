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
uniform float gray_dark_1;
uniform float gray_dark_2;

#define S(a, b, c) smoothstep(a,b,c)
// #define S(a, b, c) step(a,c)
#define EPSILON .000000001

#define PI 3.14159265359
#define PI_2 PI * 2

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    // fragCoord.y = iResolution.y - fragCoord.y;
    vec2 uv = fragCoord/iResolution.xy;

    // Time varying pixel color
    vec3 col = 0.5 + 0.5*cos(iTime+uv.xyx+vec3(0,2,4));

    // Output to screen
    fragColor = texture(iChannel1, uv);
    vec4 top_layer = texture(iChannel1, uv);
    vec4 bottom_layer = texture(iChannel1, uv);
    
    float cmp = cos(iTime/3.)*.55+.45;
    
    float low = 75.;
    float low2 = 150.;
    
    // if (base_green < cmp)
    // if (base_green - cmp < .4)
    {
        // fragColor = vec4(1);
        // fragColor = mix(vec4(1), fragColor, cmp - base_green);
        // fragColor = mix(vec4(1), fragColor, base_green - cmp);
        
        // fragColor = mix(vec4(1,0,0,1), fragColor, S(gray_dark_1,max(gray_dark_1,gray_dark_2),top_layer.r));
        // fragColor = mix(vec4(1,0,0,1), fragColor, S(gray_dark_1,max(gray_dark_1,gray_dark_2),top_layer.g));
        
        fragColor = mix(vec4(1,0,0,1), fragColor, S(gray_dark_1-EPSILON, max(gray_dark_1,gray_dark_2), top_layer.b));
        
        mat3 sep = mat3(
      //r      g      b
        0.393 , 0.769 , 0.189 ,    // Red
        0.349 , 0.686 , 0.168 ,    // Green
        0.272 , 0.534 , 0.131     // Blue
        );
        mat3 w = mat3(
      //r      g      b
        0.299 , 0.587 , 0.114 ,    // Red
        0.299 , 0.587 , 0.114 ,    // Green
        0.299 , 0.587 , 0.114     // Blue
        );
        
        fragColor.rgb *= w;
        // fragColor.rgb = vec3(dot(fragColor.rgb, vec3(.9,.33,.33)));
        
        // fragColor = mix(vec4(1,0,0,1), fragColor, S(low/255.,low2/255.,base_green));
        // fragColor = mix(fragColor, vec4(1,0,0,1), S(0.75,0.95,base_green));
    }
    
    if (uv.x > 1.)
      fragColor = vec4(1);
    
    
    uv = (fragCoord *2. - iResolution.xy) / iResolution.xy;
    
    fragColor = vec4(vec3(atan(uv.x,uv.y) / PI_2 + .5 ),1);
}

void main( void ){vec4 color = vec4(0.0,0.0,0.0,1.0); mainImage(color, gl_FragCoord.xy);color.w = 1.0;FragColor = color;}
