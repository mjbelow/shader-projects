-- # Pixel formats:
PF_U8_RGB = 1
PF_U8_BGR = 2
PF_U8_RGBA = 3
PF_U8_BGRA = 4
PF_F32_RGB = 5
PF_F32_RGBA = 6
PF_F32_R = 7
PF_F16_RGB = 8
PF_F16_RGBA = 9
PF_F16_R = 10
PF_U8_R = 11
PF_U8_RG = 12

winW, winH = gh_window.getsize()

camera_ortho = gh_camera.create_ortho(-winW/2, winW/2, -winH/2, winH/2, 1.0, 10.0)
gh_camera.set_viewport(camera_ortho, 0, 0, winW, winH)
gh_camera.set_position(camera_ortho, 0, 0, 4)

g_quad = gh_mesh.create_quad(winW, winH)

function draw_quad(x, y, width, height)
  gh_mesh.update_quad_size(g_quad, width, height)
  gh_object.set_position(g_quad, x, y, 0)
  gh_object.render(g_quad)
end

gpu_prog_buf_a = gh_node.getid("gpu_prog_buf_a")
gpu_prog_buf_b = gh_node.getid("gpu_prog_buf_b")
gpu_prog_buf_c = gh_node.getid("gpu_prog_buf_c")
gpu_prog_buf_d = gh_node.getid("gpu_prog_buf_d")
gpu_prog_img = gh_node.getid("gpu_prog_img")

do_animation = 1

if (rt0_clamp_addressing == nil) then
  rt0_clamp_addressing = 1
end  
if (rt1_clamp_addressing == nil) then
  rt1_clamp_addressing = 1
end  
if (rt2_clamp_addressing == nil) then
  rt2_clamp_addressing = 1
end  
if (rt3_clamp_addressing == nil) then
  rt3_clamp_addressing = 1
end  
if (img_clamp_addressing == nil) then
  img_clamp_addressing = 1
end  

local num_color_targets = 1
local pf = PF_F32_RGBA
local linear_filtering = 1
local samples = 0
local create_depth_texture = 0
local gen_mipmaps = 1

buf_A = 0
buf_B = 0
buf_C = 0
buf_D = 0

if (gpu_prog_buf_a > 0) then
  buf_A = gh_render_target.create_ex_v5(winW, winH, num_color_targets, pf, linear_filtering, rt0_clamp_addressing, samples, create_depth_texture, gen_mipmaps)
end
  
if (gpu_prog_buf_b > 0) then
  buf_B = gh_render_target.create_ex_v5(winW, winH, num_color_targets, pf, linear_filtering, rt1_clamp_addressing, samples, create_depth_texture, gen_mipmaps)
end
  
if (gpu_prog_buf_c > 0) then
  buf_C = gh_render_target.create_ex_v5(winW, winH, num_color_targets, pf, linear_filtering, rt2_clamp_addressing, samples, create_depth_texture, gen_mipmaps)
end
  
if (gpu_prog_buf_d > 0) then
  buf_D = gh_render_target.create_ex_v5(winW, winH, num_color_targets, pf, linear_filtering, rt3_clamp_addressing, samples, create_depth_texture, gen_mipmaps)
end
  
gen_mipmaps = 0
  
img = gh_render_target.create_ex_v5(winW, winH, num_color_targets, PF_U8_RGBA, linear_filtering, img_clamp_addressing, samples, create_depth_texture, gen_mipmaps)


-- Clear all render targets. ----------------------------------
--
gh_camera.bind(camera_ortho)
gh_renderer.set_depth_test_state(0)

-- gh_gpu_program.bind(rt_clear)
---[[
if (buf_A > 0) then
  gh_render_target.bind(buf_A)
  gh_renderer.clear_color_depth_buffers(0.0, 0.0, 0.0, 0.0, 1.0)
  draw_quad(0, 0, winW, winH)
  gh_render_target.unbind(buf_A)
end  


if (buf_B > 0) then
  gh_render_target.bind(buf_B)
  gh_renderer.clear_color_depth_buffers(0.0, 0.0, 0.0, 0.0, 1.0)
  draw_quad(0, 0, winW, winH)
  gh_render_target.unbind(buf_B)
end

if (buf_C > 0) then
  gh_render_target.bind(buf_C)
  gh_renderer.clear_color_depth_buffers(0.0, 0.0, 0.0, 0.0, 1.0)
  draw_quad(0, 0, winW, winH)
  gh_render_target.unbind(buf_C)
end

if (buf_D > 0) then
  gh_render_target.bind(buf_D)
  gh_renderer.clear_color_depth_buffers(0.0, 0.0, 0.0, 0.0, 1.0)
  draw_quad(0, 0, winW, winH)
  gh_render_target.unbind(buf_D)
end

if (img > 0) then
  gh_render_target.bind(img)
  gh_renderer.clear_color_depth_buffers(0.0, 0.0, 0.0, 0.0, 1.0)
  draw_quad(0, 0, winW, winH)
  gh_render_target.unbind(img)
end
--]]
  
-----------------------------------------------------------------


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