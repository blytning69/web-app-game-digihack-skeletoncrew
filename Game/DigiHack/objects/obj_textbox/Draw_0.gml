accept_key = keyboard_check_pressed(vk_space);
textbox_x = camera_get_view_x(view_camera[0]);
textbox_y = camera_get_view_y(view_camera[0]) + 144;

//setup 
//setup 
if setup == false {
    setup = true;
    draw_set_font(font_menu);
    draw_set_valign(fa_top);
    draw_set_halign(fa_left);
    
    //loop through the pages
    for(var p = 0; p < page_number; p++) {
        text_length[p] = string_length(text[p]);
        //get the x position for the textbox
        text_x_offset[p] = 96;
    }
    
    // TAMBAHKAN INI - Initialize untuk page yang belum ada
    if (page_number == 0) {
        text_x_offset[0] = 96;
    }
}

// Handle AI chat input
if (is_ai_chat && input_active && !waiting_for_ai) {
    // Get keyboard input for chatting with AI
    var input_string = keyboard_string;
    
    // Handle backspace
    if (keyboard_check_pressed(vk_backspace) && string_length(user_input) > 0) {
        user_input = string_delete(user_input, string_length(user_input), 1);
    }
    
    // Add new characters
    for (var i = 1; i <= string_length(input_string); i++) {
        var char = string_char_at(input_string, i);
        if (char != chr(8) && char != chr(13)) { // Not backspace or enter
            user_input += char;
        }
    }
    
    // Send message when Enter is pressed
    if (keyboard_check_pressed(vk_enter) && user_input != "") {
        send_ai_request(user_input);
        user_input = "";
        waiting_for_ai = true;
        input_active = false;
    }
    
    // Clear keyboard string
    keyboard_string = "";
}

//typing the text
if draw_char < text_length[page] {
    draw_char += text_speed;
    draw_char = clamp(draw_char, 0, text_length[page]);
}

//flip through pages
if accept_key && !input_active {
    show_debug_message("Current page: " + string(page) + "/" + string(page_number-1));
    show_debug_message("Text length: " + string(text_length[page]) + ", Draw char: " + string(draw_char));
    
    // if the typing is done
    if draw_char == text_length[page] {
        //next page
        if page < page_number - 1 {
            page++;
            draw_char = 0;
            show_debug_message("Going to next page: " + string(page));
        }
        else {
            //link text to options
            if option_number > 0 {
                create_textbox(option_link_id[option_pos]);
            }
            // If this is AI chat, activate input mode instead of destroying
            else if (is_ai_chat && !waiting_for_ai) {
                input_active = true;
                keyboard_string = "";
                show_debug_message("AI chat input activated");
            }
            else if (!is_ai_chat) {
                show_debug_message("Destroying textbox");
                instance_destroy();
            }
        }
    }
    // if not done typing
    else {
        draw_char = text_length[page];
        show_debug_message("Skip typing, set draw_char to: " + string(draw_char));
    }
}
}

//draw_textbox
var txtbx_x = textbox_x + text_x_offset[page];
var txtbx_y = textbox_y;
textbox_image += textbox_image_spd;
textbox_spr_w = sprite_get_width(textbox_spr);
textbox_spr_h = sprite_get_height(textbox_spr);

//back of the textbox
draw_sprite_ext(textbox_spr, textbox_image, textbox_x + text_x_offset[page], textbox_y, textbox_width/textbox_spr_w, textbox_height / textbox_spr_h, 0, c_white, 1);

var drawtext = string_copy(text[page], 1, draw_char);
draw_text_ext(textbox_x + text_x_offset[page] + border, textbox_y + border, drawtext, line_sep, line_width);

// Draw input field for AI chat
if (is_ai_chat && input_active) {
    // Draw input prompt
    draw_text(textbox_x + text_x_offset[page] + border, textbox_y + textbox_height - 40, "You: " + user_input + "_");
    draw_text(textbox_x + text_x_offset[page] + border, textbox_y + textbox_height - 25, "(Press Enter to send)");
}

// Show waiting message
if (waiting_for_ai) {
    draw_text(textbox_x + text_x_offset[page] + border, textbox_y + textbox_height - 40, "AI is thinking...");
}

//options (only show if not in AI chat mode)
if (!is_ai_chat && draw_char == text_length[page] && page == page_number - 1) {
    //option selection
    option_pos += keyboard_check_pressed(vk_down) - keyboard_check_pressed(vk_up);
    option_pos = clamp(option_pos, 0, option_number - 1);
    
    var op_space = 15;
    var op_bord = 4;
    for (var op = 0; op < option_number; op++) {
        //option box
        var o_w = string_width(option[op]) + op_bord * 2;
        draw_sprite_ext(textbox_spr, textbox_image, txtbx_x + 16, txtbx_y - op_space*option_number + op_space*op, o_w/textbox_spr_w, (op_space - 1)/textbox_spr_h, 0, c_white, 1);
        
        //arrow
        if option_pos == op {
            draw_sprite(textbox_arrow_spr, 0, txtbx_x, txtbx_y - op_space*option_number + op_space*op);
        }
        //the option text
        draw_text(txtbx_x + 16, txtbx_y - op_space*option_number + op_space*op + 2, option[op]);
    }
}