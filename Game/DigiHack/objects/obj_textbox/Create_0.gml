depth = -1000
    
//textbox parameters
textbox_width = 290;
textbox_height = 190; 
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
text_x_offset[0] = 96;
textbox_image_spd = 5/60;

//options
option[0] = "";
option_link_id[0] = -1;
option_pos = 0;
option_number = 0;
setup = false;

is_ai_chat = false;          // Flag to identify if this is an AI chatbot
ai_request_id = -1;          // Store the HTTP request ID
waiting_for_ai = false;      // Flag to show we're waiting for AI response
user_input = "";             // Store user's input
input_active = false;        // Flag for input mode