#version 150
out vec4 FragColor;

uniform sampler2D iChannel0;
uniform sampler2D iChannel1;
uniform vec4 iMouse;
uniform vec2 iResolution;
uniform float iTime;


#define PI 3.14159265358979323846264
#define  E 2.71828182845904523536028

vec4 multiply(vec4 a, vec4 b)
{
    return a * b;
}

vec4 screen(vec4 a, vec4 b)
{

    return 1 - ( (1 - a) * (1 - b) );

}


//Color Burn
vec4 colorBurn (vec4 target, vec4 blend){
    return 1.0 - (1.0 - target)/ blend;
}

//Linear Burn
vec4 linearBurn (vec4 target, vec4 blend){
    return target + blend - 1.0;
}

//Color Dodge
vec4 colorDodge (vec4 target, vec4 blend){
    return target / (1.0 - blend);
}

//Linear Dodge
vec4 linearDodge (vec4 target, vec4 blend){
    return target + blend;
}

//Overlay
vec4 overlay (vec4 target, vec4 blend){
    vec4 temp;
    temp.x = (target.x > 0.5) ? (1.0-(1.0-2.0*(target.x-0.5))*(1.0-blend.x)) : (2.0*target.x)*blend.x;
    temp.y = (target.y > 0.5) ? (1.0-(1.0-2.0*(target.y-0.5))*(1.0-blend.y)) : (2.0*target.y)*blend.y;
    temp.z = (target.z > 0.5) ? (1.0-(1.0-2.0*(target.z-0.5))*(1.0-blend.z)) : (2.0*target.z)*blend.z;
    return temp;
}

//Soft Light
vec4 softLight (vec4 target, vec4 blend){
 vec4 temp;
    temp.x = (blend.x > 0.5) ? (1.0-(1.0-target.x)*(1.0-(blend.x-0.5))) : (target.x * (blend.x + 0.5));
    temp.y = (blend.y > 0.5) ? (1.0-(1.0-target.y)*(1.0-(blend.y-0.5))) : (target.y * (blend.y + 0.5));
    temp.z = (blend.z > 0.5) ? (1.0-(1.0-target.z)*(1.0-(blend.z-0.5))) : (target.z * (blend.z + 0.5));
    return temp;
}

//Hard Light
vec4 hardLight (vec4 target, vec4 blend){
    vec4 temp;
    temp.x = (blend.x > 0.5) ? (1.0-(1.0-target.x)*(1.0-2.0*(blend.x-0.5))) : (target.x * (2.0*blend.x));
    temp.y = (blend.y > 0.5) ? (1.0-(1.0-target.y)*(1.0-2.0*(blend.y-0.5))) : (target.y * (2.0*blend.y));
    temp.z = (blend.z > 0.5) ? (1.0-(1.0-target.z)*(1.0-2.0*(blend.z-0.5))) : (target.z * (2.0*blend.z));
    return temp;
}

//Vivid Light
vec4 vividLight (vec4 target, vec4 blend){
     vec4 temp;
    temp.x = (blend.x > 0.5) ? (1.0-(1.0-target.x)/(2.0*(blend.x-0.5))) : (target.x / (1.0-2.0*blend.x));
    temp.y = (blend.y > 0.5) ? (1.0-(1.0-target.y)/(2.0*(blend.y-0.5))) : (target.y / (1.0-2.0*blend.y));
    temp.z = (blend.z > 0.5) ? (1.0-(1.0-target.z)/(2.0*(blend.z-0.5))) : (target.z / (1.0-2.0*blend.z));
    return temp;
}

//Linear Light
vec4 linearLight (vec4 target, vec4 blend){
    vec4 temp;
    temp.x = (blend.x > 0.5) ? (target.x)+(2.0*(blend.x-0.5)) : (target.x +(2.0*blend.x-1.0));
    temp.y = (blend.y > 0.5) ? (target.y)+(2.0*(blend.y-0.5)) : (target.y +(2.0*blend.y-1.0));
    temp.z = (blend.z > 0.5) ? (target.z)+(2.0*(blend.z-0.5)) : (target.z +(2.0*blend.z-1.0));
    return temp;
}

//Pin Light
vec4 pinLight (vec4 target, vec4 blend){
     vec4 temp;
    temp.x = (blend.x > 0.5) ? (max (target.x, 2.0*(blend.x-0.5))) : (min(target.x, 2.0*blend.x));
    temp.y = (blend.y > 0.5) ? (max (target.y, 2.0*(blend.y-0.5))) : (min(target.y, 2.0*blend.y));
    temp.z = (blend.z > 0.5) ? (max (target.z, 2.0*(blend.z-0.5))) : (min(target.z, 2.0*blend.z));
    return temp;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{

    vec2 uv = gl_FragCoord.xy/iResolution.xy;

    float cycle = PI*2.0/3.0;

    vec3 col = 0.5 + 0.5*cos(iTime+uv.xyx+vec3(0, cycle, cycle*2.0));

    vec4 tex0 = texture2D(iChannel0, uv);
    vec4 tex1 = texture2D(iChannel1, uv);
    vec4 color = vec4(col, 1.0);

    if (tex1.r < .5 && tex1.g < .5 && tex1.b < .5)
        fragColor = screen(tex0, color);
    else
        fragColor = multiply(tex1, color);

    float amt = 3.;
    float lines = mod(gl_FragCoord.y, amt);
    float inter = .2;

    float line_color = 0;

    if (lines < amt / 2.)
        line_color = 0.3;
    else
        line_color = .7;

    // fragColor = (fragColor * (1.-inter)) + (vec4(line_color) * inter);

    fragColor = pinLight(fragColor, vec4(line_color));
}

void main( void ){vec4 color = vec4(0.0,0.0,0.0,1.0); mainImage(color, gl_FragCoord.xy);color.w = 1.0;FragColor = color;}
