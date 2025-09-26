if (async_load[? "id"] == ai_request_id) {
    var status = async_load[? "status"];
    
    if (status == 0) { // Success
        var response_string = async_load[? "result"];
        
        try {
            var response_data = json_decode(response_string);
            
            // Extract the AI's response (this depends on your API)
            // Example for OpenAI format:
            var choices = response_data[? "choices"];
            if (ds_exists(choices, ds_type_list) && ds_list_size(choices) > 0) {
                var first_choice = choices[| 0];
                var message = first_choice[? "message"];
                var ai_response = message[? "content"];
                
                // Add AI response as new page
                scr_text("AI: " + string(ai_response));
                
                // Clean up JSON data
                ds_map_destroy(response_data);
            } else {
                // Fallback - treat whole response as text
                scr_text("AI: " + response_string);
            }
        } catch(e) {
            // If JSON parsing fails, show raw response
            scr_text("AI: " + response_string);
        }
        
        waiting_for_ai = false;
        page = page_number - 1;  // Go to the new AI response page
        draw_char = 0;           // Start typing animation
        
    } else {
        // Handle error
        scr_text("AI: Sorry, I'm having trouble responding right now.");
        waiting_for_ai = false;
        page = page_number - 1;
        draw_char = 0;
    }
}