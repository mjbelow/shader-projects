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

function mouse_get_position()
  local mx, my = gh_input.mouse_getpos()
  
  if (gh_utils.get_platform() == 2) then -- OSX     
    local w, h = gh_window.getsize(0)
    my = h - my
  end
    
  if (is_rpi_gles == 1) then 
    local w, h = gh_window.getsize(0)
    mx = mx + w/2
    my = -(my - h/2) 
  end
  
  return mx, my
end    


local mouse_x, mouse_y = mouse_get_position()
local mouse_quad_x = mouse_x - winW/2
local mouse_quad_y = -(mouse_y - winH/2) 


  if (gh_utils.get_platform() == 1) then
    gh_window.keyboard_update_buffer(0)
  end

  local KC_SPACE = 57
  if ((toggle) and (gh_input.keyboard_is_key_down(KC_SPACE) == 1)) then
    toggle = false
    show_imgui = not show_imgui
  end
  if (gh_input.keyboard_is_key_down(KC_SPACE) == 0) then
    toggle = true
  end

initial_state = 0
local min_value = 0
local max_value = 1.0
local power = 1.0 -- Use power!=1.0 for logarithmic sliders.
imgui_frame_begin_v2(mouse_x, mouse_y)



if show_imgui then

imgui_window_begin_v1("Top Layer", 500, 500, 0, 0)

gh_imgui.text("gray")

gray_dark_top_1 = gh_imgui.slider_1f("gray_dark_top_1", gray_dark_top_1, min_value, max_value, power)
gray_dark_top_2 = gh_imgui.slider_1f("gray_dark_top_2", gray_dark_top_2, min_value, max_value, power)
gray_light_top_1 = gh_imgui.slider_1f("gray_light_top_1", gray_light_top_1, min_value, max_value, power)
gray_light_top_2 = gh_imgui.slider_1f("gray_light_top_2", gray_light_top_2, min_value, max_value, power)



gh_imgui.text("red")

red_dark_top_1 = gh_imgui.slider_1f("red_dark_top_1", red_dark_top_1, min_value, max_value, power)
red_dark_top_2 = gh_imgui.slider_1f("red_dark_top_2", red_dark_top_2, min_value, max_value, power)
red_light_top_1 = gh_imgui.slider_1f("red_light_top_1", red_light_top_1, min_value, max_value, power)
red_light_top_2 = gh_imgui.slider_1f("red_light_top_2", red_light_top_2, min_value, max_value, power)



gh_imgui.text("green")

green_dark_top_1 = gh_imgui.slider_1f("green_dark_top_1", green_dark_top_1, min_value, max_value, power)
green_dark_top_2 = gh_imgui.slider_1f("green_dark_top_2", green_dark_top_2, min_value, max_value, power)
green_light_top_1 = gh_imgui.slider_1f("green_light_top_1", green_light_top_1, min_value, max_value, power)
green_light_top_2 = gh_imgui.slider_1f("green_light_top_2", green_light_top_2, min_value, max_value, power)



gh_imgui.text("blue")

blue_dark_top_1 = gh_imgui.slider_1f("blue_dark_top_1", blue_dark_top_1, min_value, max_value, power)
blue_dark_top_2 = gh_imgui.slider_1f("blue_dark_top_2", blue_dark_top_2, min_value, max_value, power)
blue_light_top_1 = gh_imgui.slider_1f("blue_light_top_1", blue_light_top_1, min_value, max_value, power)
blue_light_top_2 = gh_imgui.slider_1f("blue_light_top_2", blue_light_top_2, min_value, max_value, power)


imgui_window_end()

imgui_window_begin_v1("Mix", 500, 500, 500, 0)

  -- top layer
	top_layer_option = gh_imgui.combo_box_draw(combo_box_index1, 0)
  
  g_checkbox_layer1_rainbow = gh_imgui.checkbox("Rainbow ##layer1_rainbow", g_checkbox_layer1_rainbow);
  gh_imgui.same_line(0, 0);
  g_checkbox_layer1_r = gh_imgui.checkbox("R ##layer1_r", g_checkbox_layer1_r);
  gh_imgui.same_line(0, 0);
  g_checkbox_layer1_g = gh_imgui.checkbox("G ##layer1_g", g_checkbox_layer1_g);
  gh_imgui.same_line(0, 0);
  g_checkbox_layer1_b = gh_imgui.checkbox("B ##layer1_b", g_checkbox_layer1_b);
  
  -- bottom layer
	bottom_layer_option = gh_imgui.combo_box_draw(combo_box_index2, 1)
  
  g_checkbox_layer2_rainbow = gh_imgui.checkbox("Rainbow ##layer2_rainbow", g_checkbox_layer2_rainbow);
  gh_imgui.same_line(0, 0);
  g_checkbox_layer2_r = gh_imgui.checkbox("R ##layer2_r", g_checkbox_layer2_r);
  gh_imgui.same_line(0, 0);
  g_checkbox_layer2_g = gh_imgui.checkbox("G ##layer2_g", g_checkbox_layer2_g);
  gh_imgui.same_line(0, 0);
  g_checkbox_layer2_b = gh_imgui.checkbox("B ##layer2_b", g_checkbox_layer2_b);

  -- transition layer
	transition_layer_option = gh_imgui.combo_box_draw(combo_box_index3, 2)
  
  g_checkbox_layer3_rainbow = gh_imgui.checkbox("Rainbow ##layer3_rainbow", g_checkbox_layer3_rainbow);
  gh_imgui.same_line(0, 0);
  g_checkbox_layer3_r = gh_imgui.checkbox("R ##layer3_r", g_checkbox_layer3_r);
  gh_imgui.same_line(0, 0);
  g_checkbox_layer3_g = gh_imgui.checkbox("G ##layer3_g", g_checkbox_layer3_g);
  gh_imgui.same_line(0, 0);
  g_checkbox_layer3_b = gh_imgui.checkbox("B ##layer3_b", g_checkbox_layer3_b);


	gh_imgui.text("\n\nBlend Top and Bottom Layer to... ")

	if (gh_imgui.radio_button("Bottom Layer##bottom_layer", g_radio_button1_active) == 1) then
		g_radio_button1_active = 1
		g_radio_button2_active = 0
	end
	if (gh_imgui.radio_button("Transition Layer##transition_layer", g_radio_button2_active) == 1) then
		g_radio_button1_active = 0
		g_radio_button2_active = 1
	end
  

imgui_window_end()

imgui_window_begin_v1("Bottom Layer", 500, 500, 500, 0)

gh_imgui.text("gray")

gray_dark_bottom_1 = gh_imgui.slider_1f("gray_dark_bottom_1", gray_dark_bottom_1, min_value, max_value, power)
gray_dark_bottom_2 = gh_imgui.slider_1f("gray_dark_bottom_2", gray_dark_bottom_2, min_value, max_value, power)
gray_light_bottom_1 = gh_imgui.slider_1f("gray_light_bottom_1", gray_light_bottom_1, min_value, max_value, power)
gray_light_bottom_2 = gh_imgui.slider_1f("gray_light_bottom_2", gray_light_bottom_2, min_value, max_value, power)



gh_imgui.text("red")

red_dark_bottom_1 = gh_imgui.slider_1f("red_dark_bottom_1", red_dark_bottom_1, min_value, max_value, power)
red_dark_bottom_2 = gh_imgui.slider_1f("red_dark_bottom_2", red_dark_bottom_2, min_value, max_value, power)
red_light_bottom_1 = gh_imgui.slider_1f("red_light_bottom_1", red_light_bottom_1, min_value, max_value, power)
red_light_bottom_2 = gh_imgui.slider_1f("red_light_bottom_2", red_light_bottom_2, min_value, max_value, power)



gh_imgui.text("green")

green_dark_bottom_1 = gh_imgui.slider_1f("green_dark_bottom_1", green_dark_bottom_1, min_value, max_value, power)
green_dark_bottom_2 = gh_imgui.slider_1f("green_dark_bottom_2", green_dark_bottom_2, min_value, max_value, power)
green_light_bottom_1 = gh_imgui.slider_1f("green_light_bottom_1", green_light_bottom_1, min_value, max_value, power)
green_light_bottom_2 = gh_imgui.slider_1f("green_light_bottom_2", green_light_bottom_2, min_value, max_value, power)



gh_imgui.text("blue")

blue_dark_bottom_1 = gh_imgui.slider_1f("blue_dark_bottom_1", blue_dark_bottom_1, min_value, max_value, power)
blue_dark_bottom_2 = gh_imgui.slider_1f("blue_dark_bottom_2", blue_dark_bottom_2, min_value, max_value, power)
blue_light_bottom_1 = gh_imgui.slider_1f("blue_light_bottom_1", blue_light_bottom_1, min_value, max_value, power)
blue_light_bottom_2 = gh_imgui.slider_1f("blue_light_bottom_2", blue_light_bottom_2, min_value, max_value, power)


imgui_window_end()

end

gh_imgui.frame_end()




gh_gpu_program.uniform1f(gpu_prog_01, "gray_dark_top_1", gray_dark_top_1)
gh_gpu_program.uniform1f(gpu_prog_01, "gray_dark_top_2", gray_dark_top_2)
gh_gpu_program.uniform1f(gpu_prog_01, "gray_light_top_1", gray_light_top_1)
gh_gpu_program.uniform1f(gpu_prog_01, "gray_light_top_2", gray_light_top_2)

gh_gpu_program.uniform1f(gpu_prog_01, "red_dark_top_1", red_dark_top_1)
gh_gpu_program.uniform1f(gpu_prog_01, "red_dark_top_2", red_dark_top_2)
gh_gpu_program.uniform1f(gpu_prog_01, "red_light_top_1", red_light_top_1)
gh_gpu_program.uniform1f(gpu_prog_01, "red_light_top_2", red_light_top_2)

gh_gpu_program.uniform1f(gpu_prog_01, "green_dark_top_1", green_dark_top_1)
gh_gpu_program.uniform1f(gpu_prog_01, "green_dark_top_2", green_dark_top_2)
gh_gpu_program.uniform1f(gpu_prog_01, "green_light_top_1", green_light_top_1)
gh_gpu_program.uniform1f(gpu_prog_01, "green_light_top_2", green_light_top_2)

gh_gpu_program.uniform1f(gpu_prog_01, "blue_dark_top_1", blue_dark_top_1)
gh_gpu_program.uniform1f(gpu_prog_01, "blue_dark_top_2", blue_dark_top_2)
gh_gpu_program.uniform1f(gpu_prog_01, "blue_light_top_1", blue_light_top_1)
gh_gpu_program.uniform1f(gpu_prog_01, "blue_light_top_2", blue_light_top_2)



gh_gpu_program.uniform1f(gpu_prog_01, "gray_dark_bottom_1", gray_dark_bottom_1)
gh_gpu_program.uniform1f(gpu_prog_01, "gray_dark_bottom_2", gray_dark_bottom_2)
gh_gpu_program.uniform1f(gpu_prog_01, "gray_light_bottom_1", gray_light_bottom_1)
gh_gpu_program.uniform1f(gpu_prog_01, "gray_light_bottom_2", gray_light_bottom_2)

gh_gpu_program.uniform1f(gpu_prog_01, "red_dark_bottom_1", red_dark_bottom_1)
gh_gpu_program.uniform1f(gpu_prog_01, "red_dark_bottom_2", red_dark_bottom_2)
gh_gpu_program.uniform1f(gpu_prog_01, "red_light_bottom_1", red_light_bottom_1)
gh_gpu_program.uniform1f(gpu_prog_01, "red_light_bottom_2", red_light_bottom_2)

gh_gpu_program.uniform1f(gpu_prog_01, "green_dark_bottom_1", green_dark_bottom_1)
gh_gpu_program.uniform1f(gpu_prog_01, "green_dark_bottom_2", green_dark_bottom_2)
gh_gpu_program.uniform1f(gpu_prog_01, "green_light_bottom_1", green_light_bottom_1)
gh_gpu_program.uniform1f(gpu_prog_01, "green_light_bottom_2", green_light_bottom_2)

gh_gpu_program.uniform1f(gpu_prog_01, "blue_dark_bottom_1", blue_dark_bottom_1)
gh_gpu_program.uniform1f(gpu_prog_01, "blue_dark_bottom_2", blue_dark_bottom_2)
gh_gpu_program.uniform1f(gpu_prog_01, "blue_light_bottom_1", blue_light_bottom_1)
gh_gpu_program.uniform1f(gpu_prog_01, "blue_light_bottom_2", blue_light_bottom_2)

gh_gpu_program.uniform1i(gpu_prog_01, "top_layer_option", top_layer_option)
gh_gpu_program.uniform1i(gpu_prog_01, "bottom_layer_option", bottom_layer_option)

gh_gpu_program.uniform3f(gpu_prog_01, "layer_1_channels", g_checkbox_layer1_r, g_checkbox_layer1_g, g_checkbox_layer1_b)
gh_gpu_program.uniform3f(gpu_prog_01, "layer_2_channels", g_checkbox_layer2_r, g_checkbox_layer2_g, g_checkbox_layer2_b)

gh_gpu_program.uniform1i(gpu_prog_01, "layer_1_rainbow", g_checkbox_layer1_rainbow)
gh_gpu_program.uniform1i(gpu_prog_01, "layer_2_rainbow", g_checkbox_layer2_rainbow)

if(g_radio_button1_active == 1) then
  gh_gpu_program.uniform1i(gpu_prog_01, "transition_layer_option", bottom_layer_option)
  gh_gpu_program.uniform3f(gpu_prog_01, "layer_3_channels", g_checkbox_layer2_r, g_checkbox_layer2_g, g_checkbox_layer2_b)
  gh_gpu_program.uniform1i(gpu_prog_01, "layer_3_rainbow", g_checkbox_layer2_rainbow)
else
  gh_gpu_program.uniform1i(gpu_prog_01, "transition_layer_option", transition_layer_option)
  gh_gpu_program.uniform3f(gpu_prog_01, "layer_3_channels", g_checkbox_layer3_r, g_checkbox_layer3_g, g_checkbox_layer3_b)
  gh_gpu_program.uniform1i(gpu_prog_01, "layer_3_rainbow", g_checkbox_layer3_rainbow)
end

