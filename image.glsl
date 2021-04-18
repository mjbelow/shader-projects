#version 150
out vec4 FragColor;

uniform sampler2D iChannel0;
uniform sampler2D iChannel1;
uniform vec4 iMouse;
uniform vec2 iResolution;
uniform float iTime;


/* 

Uncomment code to see Sawtooth and Triangle Waves etc. 
   
*/

const int NUM_WAVES = 5;
float pi = atan(1.0) * 4.0;
float y;

float Wave(vec2 p, float amplitude, float frequence,float offset_y)
{
   	// basic sine wave ----------------------------------------------------
    
    y =  amplitude*(sin(p.x*frequence))+offset_y;
    
    // sine wave with a sampled look --------------------------------------
    
    //y =  amplitude*(sin(float(int(p.x*frequence))))+offset_y;
    
    // semi random city scape ---------------------------------------------
    
    y =  amplitude*(sin(float(int(p.x*frequence))*4.))+offset_y;
    
    
    // triangle wave. -----------------------------------------------------
    
    //y = amplitude*(abs(mod(p.x*frequence,2.0)-1.))+offset_y;
    
    // "sinewave" pattern with a smoothed triangle wave -------------------
   
    //float triangle = abs(mod(p.x*frequence,2.0)-1.);
    //y = amplitude*(triangle*triangle*(3.0 - 2.0 *triangle))+offset_y;
    
    // sawtooth -----------------------------------------------------------
    // Return only the fraction part of a number. This is calculated as x - floor(x).
    
    //y = amplitude*(fract(p.x*frequence))+offset_y;
    
    
	return p.y + y;
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 st = fragCoord/iResolution.xy;
    float colour;
   	float wave;
    
    st=10.0*st-5.;
    st.x+=iTime;
     for(int j = NUM_WAVES; j >0; j--)
    {
        float i = float(j); 
        
        // wave generation 
        wave = Wave(st,1./i,i,2.0/i);
        // fill underneath the curve
        wave = step(1.-wave,1.0);
        // mix with previous wave in the loop 
        colour = mix(1.-.15*i,colour,wave);
    	
    }

    fragColor = vec4(vec3(colour),1.0);
}


void main( void ){vec4 color = vec4(0.0,0.0,0.0,1.0); mainImage(color, gl_FragCoord.xy);color.w = 1.0;FragColor = color;}
