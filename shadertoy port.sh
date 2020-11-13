#!/bin/sh

cat << EOF > "$1.glsl"
#version 120
uniform sampler2D iChannel0;
uniform sampler2D iChannel1;
uniform vec4 iMouse;
uniform vec2 iResolution;
uniform float iTime;

EOF

sed -E \
-e 's;mainImage[^(]*\([^)]+\);main\(void\);g' \
-e 's;fragColor;gl_FragColor;g' \
-e 's;fragCoord;gl_FragCoord;g' \
-e 's;gl_FragCoord([^.]);gl_FragCoord.xy\1;g' \
-e 's;texture\(;texture2D\(;g' \
"$1" >> "$1.glsl"

# read -p "Press any key to resume ..."