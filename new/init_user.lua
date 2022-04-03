

--[[
local demo_dir = gh_utils.get_demo_dir()  
local abs_path = 0
local PF_U8_RGB = 1
local PF_U8_RGBA = 3
local pixel_format = PF_U8_RGB
local gen_mipmaps = 1
local compressed_texture = 0
local free_cpu_memory = 1
tex11_noise = gh_texture.create_from_file_v6(demo_dir .. "../_data/tex11.png", pixel_format, gen_mipmaps, compressed_texture)
tex16_fine_noise = gh_texture.create_from_file_v6(demo_dir .. "../_data/tex16.png", pixel_format, gen_mipmaps, compressed_texture)
tex09 = gh_texture.create_from_file_v6(demo_dir .. "../_data/tex09.jpg", pixel_format, gen_mipmaps, compressed_texture)
tex19 = gh_texture.create_from_file_v6(demo_dir .. "../_data/tex19.png", pixel_format, gen_mipmaps, compressed_texture)


abs_path = 0
-- cubemap = gh_texture.create_cube_from_file(demo_dir .. "../_data/skybox08_posx.jpg", "./_data/skybox08_negx.jpg", "./_data/skybox08_posy.jpg", "./_data/skybox08_negy.jpg", "./_data/skybox08_posz.jpg", "./_data/skybox08_negz.jpg", PF_U8_RGBA, abs_path, gen_mipmaps)
cubemap = gh_texture.create_cube_from_file("../_data/skybox08_posx.jpg", "../_data/skybox08_negx.jpg", "../_data/skybox08_posy.jpg", "../_data/skybox08_negy.jpg", "../_data/skybox08_posz.jpg", "../_data/skybox08_negz.jpg", PF_U8_RGBA, abs_path, 0)
--]]

