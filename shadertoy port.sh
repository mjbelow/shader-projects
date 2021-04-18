#!/bin/sh

cat << EOF > "$1.glsl"
#version 150
out vec4 FragColor;

uniform sampler2D iChannel0;
uniform sampler2D iChannel1;
uniform vec4 iMouse;
uniform vec2 iResolution;
uniform float iTime;


EOF

sed '' "$1" >> "$1.glsl"

cat << EOF >> "$1.glsl"


void main( void ){vec4 color = vec4(0.0,0.0,0.0,1.0); mainImage(color, gl_FragCoord.xy);color.w = 1.0;FragColor = color;}
EOF