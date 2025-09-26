function scr_text(_text){
    text[page_number] = _text;
    text_length[page_number] = string_length(_text);
    text_x_offset[page_number] = 96;  // Fix: initialize offset untuk setiap page
    page_number++;
}

function scr_option(_option, _link_id) {
    option[option_number] = _option;
    option_link_id[option_number] = _link_id;
    option_number++;
}

function create_textbox(_text_id) {
    with (instance_create_depth(0, 0, -9999, obj_textbox)) {
        scr_game_text(_text_id);
    }
}

// NEW FUNCTION: Create AI chatbot
function create_ai_chatbot(_initial_message) {
    with (instance_create_depth(0, 0, -9999, obj_textbox)) {
        is_ai_chat = true;
        scr_text(_initial_message);
    }
}