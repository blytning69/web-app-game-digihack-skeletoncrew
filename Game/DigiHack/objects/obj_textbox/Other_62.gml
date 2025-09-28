if (async_load[? "id"] == ai_request_id) {
    var status = async_load[? "status"];
    
    if (status == 0) { // Success
        var response_string = async_load[? "result"];
        
        try {
            var response_data = json_decode(response_string);
            var ai_response = response_data[? "answer"];
            
            if (ai_response != undefined && ai_response != "") {
                scr_text("AI: " + string(ai_response));
            } else {
                scr_text("AI: " + response_string);
            }
            
            ds_map_destroy(response_data);
        } catch(e) {
            scr_text("AI: " + response_string);
        }
        
        // HAPUS semua kode update ukuran - biar Step Event yang handle
        
        waiting_for_ai = false;
        page = page_number - 1;
        draw_char = 0;
    } else {
        scr_text("AI: Sorry, I'm having trouble responding right now.");
        
        waiting_for_ai = false;
        page = page_number - 1;
        draw_char = 0;
    }
}