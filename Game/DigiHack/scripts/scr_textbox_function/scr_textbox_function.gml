function scr_text(_text){
    text[page_number] = _text;
    text_length[page_number] = string_length(_text);
    text_x_offset[page_number] = 0;  
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
// GANTI fungsi create_ai_chatbot yang lama dengan ini:


//AI
function send_ai_request(user_message) {
    var url = "https://morenoadhikusuma--math-ai-server-fastapi-app.modal.run/ask";
    
    // Create request data
    var request_data = ds_map_create();
    request_data[? "question"] = user_message;
    
    // Convert to JSON
    var json_string = json_encode(request_data);
    
    // Set headers
    var headers = ds_map_create();
    headers[? "Content-Type"] = "application/json";
    
    // Send request
    ai_request_id = http_request(url, "POST", headers, json_string);
    
    // Clean up
    ds_map_destroy(request_data);
    ds_map_destroy(headers);
    
    // Show user message
    scr_text("You: " + user_message);
}
