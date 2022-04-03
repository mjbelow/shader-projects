
#version 150
in vec4 gxl3d_Position;
in vec4 gxl3d_TexCoord0;
uniform mat4 gxl3d_ModelViewProjectionMatrix;
out vec4 v_texcoord;
void main()
{
  gl_Position = gxl3d_ModelViewProjectionMatrix * gxl3d_Position;   
  v_texcoord = gxl3d_TexCoord0;
}

