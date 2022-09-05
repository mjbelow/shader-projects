uniform sampler2D iChannel0;
uniform sampler2D iChannel1;
uniform vec4 iMouse;
uniform vec2 iResolution;
uniform float iTime;

float customRound(float f, float c)
{
    return floor(f / c) * c;
}

vec2 customRound(vec2 f, float c)
{
    return vec2(customRound(f.x, c), customRound(f.y, c));
}

void screen(float f, inout vec4 color)
{
f *= .75;
color = 1. - ((1.-f) * (1.-color));
}

void main(void)
{
	iTime /= 1.;
    /*
    // Normalized pixel coordinates (from 0 to 1)
    
    vec2 coord = gl_FragCoord.xy;
    
    if (int(gl_FragCoord.y) % 100 < 50)
        coord.x += sin(iTime*2.)*20.0;
    else
    	coord.x += sin(iTime*2.+.2)*20.0;
    
    vec2 uv = (coord)/iResolution.xy;

    //if(((int)iResolution.y) % 6 == 0)
        //uv /= 3.;
    
    //uv.x += 36.;
    
    //int d = int(gl_FragCoord.y);
    //if (d % 6 == 0)
        //uv /= 4.;
    
    // sample texture and output to screen
    gl_FragColor = texture2D(iChannel0, uv);
    */
    bool water = false;
    vec2 uv = gl_FragCoord.xy / iResolution.xy;
    uv.y *= -1.;
    vec2 uv2 = customRound(uv, .04);
    vec2 uv3 = uv;
    // uv3.y += iTime/30.*-1;
    
	
	float hmm = 0.02*cos((-iTime)*2.+uv2.y*400.)*6.;
	float hmm2 = cos((-iTime)*2.+uv2.y*400.-3.14159/2.) * .3 + .7;
	// hmm = sin(iTime+uv2.y)*.12;
	float hmm_deriv = sin(400.*uv2.y-.5*iTime)*3./50.;
	hmm_deriv = cos(iTime+uv2.y)*.12;
	hmm_deriv = 0.02*-sin((-iTime)*2.+uv2.y*400.)*6.;
	float hmm_deriv2 = -48.*sin(-1./2.*iTime + 400. * uv2.y);
	
    // if (uv.x > .4 && uv.x < .6)
    {
    	// uv2.x += 0.02*cos(-iTime*4.+uv2.y*64.);
    	uv3.x += hmm;
        water = true;
    }
    
    gl_FragColor = texture2D(iChannel0,uv);
    
	water = uv3.x > .4 && uv3.x < .6;
	
    if(water)
    {
        gl_FragColor = texture2D(iChannel0, uv3);
		vec4 original = gl_FragColor;
        // gl_FragColor = texture2D(iChannel0, uv2);
        gl_FragColor.rg *= vec2(.25,.5);
		gl_FragColor = mix(original, gl_FragColor, hmm2);
    }
	
	float c = abs(.5 - uv.x);
	
	
	
	// if(hmm < -.1 && uv3.x < .6)
	if(hmm_deriv > 0 || !water)
	{
		// gl_FragColor = vec4(1,0,0,0);
		screen(step(.99, 1.-c), gl_FragColor);
	}
	else
	{
		screen(step(.99, 1.-c)*.25, gl_FragColor);
	}
}