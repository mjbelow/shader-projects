
--kx_resize()

winW, winH = gh_window.getsize(0)
gh_mesh.update_quad_size(g_quad, winW, winH)

gh_camera.update_ortho(camera_ortho, -winW/2, winW/2, -winH/2, winH/2, 1.0, 10.0)
gh_camera.set_viewport(camera_ortho, 0, 0, winW, winH)


---[[
gh_camera.bind(camera_ortho)
gh_renderer.set_depth_test_state(0)

gh_gpu_program.bind(rt_clear)

if (buf_A > 0) then
  gh_render_target.resize(buf_A, winW, winH)
  gh_render_target.bind(buf_A)
  gh_renderer.clear_color_depth_buffers(0.0, 0.0, 0.0, 1.0, 1.0)
  draw_quad(0, 0, winW, winH)
  gh_render_target.unbind(buf_A)
end  

if (buf_B > 0) then
  gh_render_target.resize(buf_B, winW, winH)
  gh_render_target.bind(buf_B)
  gh_renderer.clear_color_depth_buffers(0.0, 0.0, 0.0, 1.0, 1.0)
  draw_quad(0, 0, winW, winH)
  gh_render_target.unbind(buf_B)
end

if (buf_C > 0) then
  gh_render_target.resize(buf_C, winW, winH)
  gh_render_target.bind(buf_C)
  gh_renderer.clear_color_depth_buffers(0.0, 0.0, 0.0, 1.0, 1.0)
  draw_quad(0, 0, winW, winH)
  gh_render_target.unbind(buf_C)
end

if (buf_D > 0) then
  gh_render_target.resize(buf_D, winW, winH)
  gh_render_target.bind(buf_D)
  gh_renderer.clear_color_depth_buffers(0.0, 0.0, 0.0, 1.0, 1.0)
  draw_quad(0, 0, winW, winH)
  gh_render_target.unbind(buf_D)
end

if (img > 0) then
  gh_render_target.resize(img, winW, winH)
  gh_render_target.bind(img)
  gh_renderer.clear_color_depth_buffers(0.0, 0.0, 0.0, 0.0, 1.0)
  draw_quad(0, 0, winW, winH)
  gh_render_target.unbind(img)
end
--]]  

