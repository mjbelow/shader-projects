#version 330
out vec4 FragColor;
in vec4 v_texcoord;

uniform vec3 iResolution;
uniform float iTime;
uniform int iFrame;
uniform vec4 iMouse;

uniform sampler2D iChannel0;

float sdBox( in vec2 p, in vec2 b )
{
    vec2 d = abs(p)-b;
    return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    
    vec2 uv = fragCoord/iResolution.xy;
    //fragColor = texelFetch(iChannel0, ivec2(fragCoord), 0);
    fragColor = texture(iChannel0, uv);

    float r = fragColor.a;
    
    if(iFrame == 0)
    {
    fragColor = vec4(1);
    return;
    }

	//fragColor = vec4(0);
    //fragColor = vec4(0,pressure,0,0);
    
    //float dd = length(uv);
    //fragColor = vec4(dd);
    
    
    if (iMouse.z > 0.0) {
        vec2 uv2 = (fragCoord - iMouse.xy) / iResolution.y;
        

        
        float d = sdBox(uv2, vec2(.05));
        //d = length(uv2) - .1;
        
        vec4 bg = vec4(0, .5, 1, 1);
        vec4 fg = vec4(1) - bg;
        
        r = min(r, step(0., d));
        // r = max(r, 1.-step(0., d));
        
        vec4 fColor2 = vec4(r);
        
        fragColor = mix(bg, fg, r);
        
        fragColor.a = r;

    }
}

void main( void ){vec4 color = vec4(0.0,0.0,0.0,0.0);mainImage( color, gl_FragCoord.xy );FragColor = color;}
