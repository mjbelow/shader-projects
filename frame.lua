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

gh_gpu_program.bind(gpu_prog_01)

gh_gpu_program.uniform1i(gpu_prog_01, "iChannel0", 0)
gh_gpu_program.uniform1i(gpu_prog_01, "iChannel1", 1)
gh_gpu_program.uniform1i(gpu_prog_01, "iChannel2", 2)
gh_gpu_program.uniform1i(gpu_prog_01, "iChannel3", 3)
gh_gpu_program.uniform1i(gpu_prog_01, "iChannel4", 4)
gh_gpu_program.uniform1i(gpu_prog_01, "iChannel5", 5)
gh_gpu_program.uniform1i(gpu_prog_01, "iChannel6", 6)
gh_gpu_program.uniform1i(gpu_prog_01, "iChannel7", 7)

local mx, my = gh_input.mouse_getpos()
local mz = gh_input.mouse_get_button_state(1)
local mw = mz

gh_gpu_program.uniform4f(gpu_prog_01, "iMouse", mx, -(my - winH), mz, mw)
gh_gpu_program.uniform2f(gpu_prog_01, "iResolution", winW, winH)
gh_gpu_program.uniform1f(gpu_prog_01, "iTime", elapsed_time)



local px = mx - winW/2
local py = winH/2 - my
gh_object.set_position(quad, px, py, 0)
-- gh_object.set_position(quad, (winW/2) - (546 / 2), (winH/2) - (528/2), 0)

gh_object.render(fullscreen_quad)
-- gh_object.render(quad)


gh_renderer.set_blending_state(0)