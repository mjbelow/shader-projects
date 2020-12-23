uniform sampler2D iChannel0;
uniform sampler2D iChannel1;
uniform vec4 iMouse;
uniform vec2 iResolution;
uniform float iTime;

// inspired by https://www.shadertoy.com/view/lllSRj


void main(void) { 

// --- color version (base = 110 chars)
    gl_FragColor = step(texture2D(iChannel0, gl_FragCoord.xy/8.).r, texture2D(iChannel1,gl_FragCoord.xy/iResolution.xy));

    
    
// --- color version + gamma correction ( + 15 chars):     
//   gl_FragColor += step(pow(texture2D(iChannel0, gl_FragCoord.xy/8.),vec4(.45)), texture2D(iChannel1,gl_FragCoord.xy/iResolution.xy));

    
    
// --- B&W version ( base + 1 chars): 
// texture2D(iChannel0, gl_FragCoord.xy/8.).r < texture2D(iChannel1,gl_FragCoord.xy/iResolution.xy).r  ? gl_FragColor++ : gl_FragColor;
    

    
// --- B&W version + gamma correction ( + 9 chars): 
// pow(texture2D(iChannel0, gl_FragCoord.xy/8.).r, .45) < texture2D(iChannel1,gl_FragCoord.xy/iResolution.xy).r  ? gl_FragColor++ : gl_FragColor;
}
