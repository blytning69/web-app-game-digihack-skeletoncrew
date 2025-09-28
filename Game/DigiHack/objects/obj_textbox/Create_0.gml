depth = -1000;
//textbox parameters - dinamis berdasarkan camera
textbox_width = camera_get_view_width(view_camera[0]);
textbox_height = camera_get_view_height(view_camera[0]) / 2;
border = 8;
line_sep = 12;
line_width = textbox_width - border*2;
//text 
page = 0;
page_number = 0;
text[0] = "";
text_length[0] = string_length(text[0]);
draw_char = 0;
text_speed = 1;
textbox_spr = bgtext_sprite;
textbox_image = 0;
textbox_image_spd = 5/60;
//options
option[0] = "";
option_link_id[0] = -1;
option_pos = 0;
option_number = 0;
setup = false;

// AI Chatbot variables
is_ai_chat = false;
ai_request_id = -1;
waiting_for_ai = false;
user_input = "";
input_active = false;
text_x_offset[0] = 0;
game_paused = false;

