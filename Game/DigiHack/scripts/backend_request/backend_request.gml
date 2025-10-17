/// @func backend_request(endpoint, method, body, use_token)
/// @param endpoint
/// @param method
/// @param body
/// @param use_token
function backend_request(endpoint, method, body, use_token)
{
    if (!variable_global_exists("api_base"))
        global.api_base = "https://web-app-game-digihack-skeletoncrew.onrender.com/";
    if (!variable_global_exists("access_token"))
        global.access_token = "";

    var headers = ds_map_create();
    ds_map_add(headers, "Content-Type", "application/x-www-form-urlencoded");

    if (use_token && global.access_token != "")
        ds_map_add(headers, "Authorization", "Bearer " + global.access_token);

    var url = global.api_base + endpoint;

    var buffer_id = -1;
    if (string_length(body) > 0) {
        buffer_id = buffer_create(string_length(body) + 1, buffer_grow, 1);
        buffer_write(buffer_id, buffer_text, body);
        buffer_seek(buffer_id, buffer_seek_start, 0);
    }

    var req = http_request(url, method, headers, buffer_id);

    if (buffer_id != -1) buffer_delete(buffer_id); 
    ds_map_destroy(headers);

    return req;
}


