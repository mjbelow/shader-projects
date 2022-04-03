#version 330
out vec4 FragColor;
in vec4 v_texcoord;

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	fragColor = vec4(0);
}

void main( void ){vec4 color = vec4(0.0,0.0,0.0,0.0);mainImage( color, gl_FragCoord.xy );FragColor = color;}
