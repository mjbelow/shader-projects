mx, my = gh_input.mouse_getpos()
mz = gh_input.mouse_get_button_state(1)
mw = mz

function bind_target_gpu_prog(render_target, gpu_prog)

  gh_render_target.bind(render_target)
  
  --gh_renderer.clear_color_depth_buffers(0.0, 0.0, 0.0, 0.0, 1.0)
  gh_gpu_program.bind(gpu_prog)
  
  -- textures
  gh_gpu_program.uniform1i(gpu_prog, "iChannel0", 0)
  gh_gpu_program.uniform1i(gpu_prog, "iChannel1", 1)
  gh_gpu_program.uniform1i(gpu_prog, "iChannel2", 2)
  gh_gpu_program.uniform1i(gpu_prog, "iChannel3", 3)
  -- cubes
  gh_gpu_program.uniform1i(gpu_prog, "iChannel4", 4)
  gh_gpu_program.uniform1i(gpu_prog, "iChannel5", 5)
  gh_gpu_program.uniform1i(gpu_prog, "iChannel6", 6)
  gh_gpu_program.uniform1i(gpu_prog, "iChannel7", 7)
  -- buffers
  gh_gpu_program.uniform1i(gpu_prog, "iChannel8", 8)
  gh_gpu_program.uniform1i(gpu_prog, "iChannel9", 9)
  gh_gpu_program.uniform1i(gpu_prog, "iChannel10", 10)
  gh_gpu_program.uniform1i(gpu_prog, "iChannel11", 11)
  
  gh_gpu_program.uniform4f(gpu_prog, "iMouse", mx, -(my - winH), mz, mw)
  gh_gpu_program.uniform2f(gpu_prog, "iResolution", winW, winH)
  gh_gpu_program.uniform1f(gpu_prog, "iTime", elapsed_time)
  

  draw_quad(0, 0, winW, winH)  
  
  gh_render_target.unbind(render_target)

end

elapsed_time = gh_utils.get_elapsed_time()


gh_camera.bind(camera_ortho)

gh_renderer.clear_color_depth_buffers(0.2, 0.2, 0.2, 1.0, 1.0)
gh_renderer.set_depth_test_state(0)




gh_texture.bind(iChannel0, 0)
-- gh_texture.unbind(tex0, 0)
gh_texture.bind(iChannel1, 1)
gh_texture.bind(iChannel2, 2)
gh_texture.bind(iChannel3, 3)
gh_texture.bind(iChannel4, 4)
gh_texture.bind(iChannel5, 5)
gh_texture.bind(iChannel6, 6)
gh_texture.bind(iChannel7, 7)

gh_texture.rt_color_bind(buf_A, 8)
gh_texture.rt_color_bind(buf_B, 9)
gh_texture.rt_color_bind(buf_C, 10)
gh_texture.rt_color_bind(buf_D, 11)


if ((do_animation == 1) and (buf_A > 0) and (gpu_prog_buf_a > 0)) then

  bind_target_gpu_prog(buf_A, gpu_prog_buf_a);
    
end  

if ((do_animation == 1) and (buf_B > 0) and (gpu_prog_buf_b > 0)) then

  bind_target_gpu_prog(buf_B, gpu_prog_buf_b);
    
end  

if ((do_animation == 1) and (buf_C > 0) and (gpu_prog_buf_c > 0)) then

  bind_target_gpu_prog(buf_C, gpu_prog_buf_c);
    
end  

if ((do_animation == 1) and (buf_D > 0) and (gpu_prog_buf_d > 0)) then

  bind_target_gpu_prog(buf_D, gpu_prog_buf_d);
    
end  

if ((do_animation == 1) and (img > 0) and (gpu_prog_img > 0)) then

  bind_target_gpu_prog(img, gpu_prog_img);
    
end  



gh_renderer.set_blending_state(0)

gh_texture.rt_color_bind(img, 0)
gh_object.render(g_quad)