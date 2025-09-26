function send_ai_request(user_message) {
    // Using Hugging Face Inference API (Free, no API key required)
    var url = "http://httpbin.org/get";
    
    // Create request data
    var request_data = ds_map_create();
    request_data[? "inputs"] = user_message;
    
    // Convert to JSON
    var json_string = json_encode(request_data);
    
    // Set headers (no authorization needed!)
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