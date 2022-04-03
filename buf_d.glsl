#version 150
out vec4 FragColor;

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    fragColor = vec4(1,0,0,1);
}

void main( void ){vec4 color = vec4(0.0,0.0,0.0,1.0); mainImage(color, gl_FragCoord.xy);color.w = 1.0;FragColor = color;}
