


if (display_info == 1) then

  imgui_frame_begin()

  gh_imgui.set_color(IMGUI_WINDOW_BG_COLOR, 0.1, 0.1, 0.1, 0.8)

  local is_open = imgui_window_begin_pos_size_always("Control panel", 320, winH, 0, 0)
  is_gui_hovered = imgui_is_hovered()
  if (is_open == 1) then


        
    if (gh_imgui.button("Demo @ Shadertoy", 160, 24) == 1) then
      gh_utils.open_url(shadertoy_demo_url)
    end

    gh_imgui.spacing()
    gh_imgui.spacing()

    gh_imgui.text(string.format("FPS: %.0f", fps))
    gh_imgui.text(string.format("Time step: %.3f ms", dt*1000.0))
    gh_imgui.spacing()
    gh_imgui.spacing()
    gh_imgui.text(string.format("GL_RENDERER: %s", gl_renderer))
    gh_imgui.text(string.format("GL_VERSION: %s", gl_version))

    gh_imgui.text(string.format("Resolution: %dx%d", winW, winH))

    gh_imgui.spacing()
    gh_imgui.spacing()
    
    local new_vsync = gh_imgui.checkbox("VSYNC", vsync)
    if (new_vsync ~= vsync) then
      vsync = new_vsync
      gh_renderer.vsync(vsync)
    end

    do_animation = gh_imgui.checkbox("Animate (SPACE key)", do_animation)




    gh_imgui.spacing()
    gh_imgui.spacing()
    gh_imgui.spacing()
    gh_imgui.spacing()
    

    if (num_gpus > 0) then

      gh_imgui.separator()

      if ((elapsed_time - gpumon_last_time) > 1.0) then
        gpumon_last_time = elapsed_time
        gh_gml.update()
      end
        
      local gpu_name = gh_gml.get_gpu_name(0)
      local vendor_id, device_id = gh_gml.get_device_id(0)
      local gpu_usage, mem_usage = gh_gml.get_usages(0)
      local gpu_temp = gh_gml.get_temperatures(0)
      local gpu_power_percent = -1
      local gpu_power_watts = -1
      if (vendor_id == 4318) then -- nvidia: 0x10de 
        gpu_power_percent = gh_gml.gpu_power_get_current_value(0)
        --gpu_power_watts = gh_gml.get_current_power_watts_nv(0)
      end
      if ((vendor_id == 4098) and (gh_gml.amd_get_overdrive_version(0) >= 8)) then -- amd: 0x1002 
        gpu_power_watts = gh_gml.amd_get_power_rdna(0)
      end


      gh_imgui.text(string.format("GPU name: %s", gpu_name))
      gh_imgui.text(string.format("GPU device ID: %4X-%4X", vendor_id, device_id))

      local flags = ImGuiTableFlags_Resizable + ImGuiTableFlags_Borders
      if (gh_imgui.table_begin("Table1", 2, flags, 0,0, 0) == 1) then
        gh_imgui.table_setup_column("Sensor")
        gh_imgui.table_setup_column("Value")
        gh_imgui.table_headers_row()
        
        -- gh_imgui.table_next_column()
        -- gh_imgui.text("GPU name")
        -- gh_imgui.table_next_column()
        -- gh_imgui.text(gpu_name)
      
        -- gh_imgui.table_next_column()
        -- gh_imgui.text("GPU device ID")
        -- gh_imgui.table_next_column()
        -- gh_imgui.text(string.format("%4X-%4X", vendor_id, device_id))
      
        gh_imgui.table_next_column()
        gh_imgui.text("temperature")
        gh_imgui.table_next_column()
        gh_imgui.text(string.format("%.0f°C", gpu_temp))

        gh_imgui.table_next_column()
        gh_imgui.text("usage")
        gh_imgui.table_next_column()
        gh_imgui.text(string.format("%.0f", gpu_usage))

        if (gpu_power_percent > -1) then
          gh_imgui.table_next_column()
          gh_imgui.text("power")
          gh_imgui.table_next_column()
          gh_imgui.text(string.format("%.0f", gpu_power_percent) .. "%% TDP")
        end

        if (gpu_power_watts > -1) then
          gh_imgui.table_next_column()
          gh_imgui.text("power")
          gh_imgui.table_next_column()
          gh_imgui.text(string.format("%.0fW", gpu_power_watts))
        end

        gh_imgui.table_end()
      end

        -- gh_imgui.text(string.format("GPU name: %s", gpu_name))
      -- gh_imgui.text(string.format("GPU device ID: %4X-%4X", vendor_id, device_id))
      -- gh_imgui.text(string.format("GPU temp: %.0f°C", gpu_temp))
      -- gh_imgui.text(string.format("GPU load: %.0f", gpu_usage) .. "%%")
      -- if (gpu_power_percent > -1) then
      --   gh_imgui.text(string.format("GPU power: %.0f", gpu_power_percent) .. "%% TDP")
      -- end
      -- if (gpu_power_watts > -1) then
      --   gh_imgui.text(string.format("GPU power: %.0fW", gpu_power_watts))
      -- end

    end



    if demo_gui~=nil then 
      gh_imgui.spacing()
      gh_imgui.spacing()
      gh_imgui.separator()
      demo_gui() 
    end


    gh_imgui.spacing()
    gh_imgui.spacing()
    gh_imgui.separator()
    gh_imgui.text_rgba(string.format("GeeXLab %s", app_version_str), 0.8, 0.8, 0.8, 1.0)

  end 

  imgui_window_end()
  imgui_frame_end()
end
