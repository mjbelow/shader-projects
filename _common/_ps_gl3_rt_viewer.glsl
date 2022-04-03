
#version 150
out vec4 FragColor;
in vec4 v_texcoord;
uniform sampler2D tex0;
void main()
{
  vec2 uv = v_texcoord.xy;
  vec4 c = texture(tex0, uv);
  FragColor = c;
}

