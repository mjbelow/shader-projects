-- # Pixel formats:
PF_U8_RGB = 1
PF_U8_BGR = 2
PF_U8_RGBA = 3
PF_U8_BGRA = 4
PF_F32_RGB = 5
PF_F32_RGBA = 6
PF_F32_R = 7
PF_U8_R = 11
PF_U8_RG = 12

local gen_mipmaps = 0

winW, winH = gh_window.getsize()




camera_ortho = gh_camera.create_ortho(-winW/2, winW/2, -winH/2, winH/2, 1.0, 10.0)
gh_camera.set_viewport(camera_ortho, 0, 0, winW, winH)
gh_camera.set_position(camera_ortho, 0, 0, 4)


gpu_prog_01 = gh_node.getid("gpu_program01")

fullscreen_quad = gh_mesh.create_quad(winW, winH)
quad = gh_mesh.create_quad(546, 528)

local abs_path = 0
iChannel0 = gh_texture.create_from_file("iChannel0.png", PF_U8_RGBA, abs_path)
iChannel1 = gh_texture.create_from_file("iChannel1.png", PF_U8_RGBA, abs_path)
iChannel2 = gh_texture.create_from_file("iChannel2.png", PF_U8_RGBA, abs_path)
iChannel3 = gh_texture.create_from_file("iChannel3.png", PF_U8_RGBA, abs_path)

iChannel4 = gh_texture.create_cube_from_file("iChannel4/px.png", "iChannel4/nx.png", "iChannel4/py.png", "iChannel4/ny.png", "iChannel4/pz.png", "iChannel4/nz.png", abs_path, PF_U8_RGBA, gen_mipmaps)
iChannel5 = gh_texture.create_cube_from_file("iChannel5/px.png", "iChannel5/nx.png", "iChannel5/py.png", "iChannel5/ny.png", "iChannel5/pz.png", "iChannel5/nz.png", abs_path, PF_U8_RGBA, gen_mipmaps)
iChannel6 = gh_texture.create_cube_from_file("iChannel6/px.png", "iChannel6/nx.png", "iChannel6/py.png", "iChannel6/ny.png", "iChannel6/pz.png", "iChannel6/nz.png", abs_path, PF_U8_RGBA, gen_mipmaps)
iChannel7 = gh_texture.create_cube_from_file("iChannel7/px.png", "iChannel7/nx.png", "iChannel7/py.png", "iChannel7/ny.png", "iChannel7/pz.png", "iChannel7/nz.png", abs_path, PF_U8_RGBA, gen_mipmaps)


gh_renderer.set_vsync(1)
gh_renderer.set_scissor_state(0)


BLEND_FACTOR_ZERO = 0
BLEND_FACTOR_ONE = 1
BLEND_FACTOR_SRC_ALPHA = 2
BLEND_FACTOR_ONE_MINUS_DST_ALPHA = 3
BLEND_FACTOR_ONE_MINUS_DST_COLOR = 4
BLEND_FACTOR_ONE_MINUS_SRC_ALPHA = 5
BLEND_FACTOR_DST_COLOR = 6
BLEND_FACTOR_DST_ALPHA = 7
BLEND_FACTOR_SRC_COLOR = 8
BLEND_FACTOR_ONE_MINUS_SRC_COLOR = 9