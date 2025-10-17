

function signup_user(_username, _password) {
    if (!variable_global_exists("API_BASE_URL")) {
        global.API_BASE_URL = "https://web-app-game-digihack-skeletoncrew.onrender.com";
    }

    var url = global.API_BASE_URL + "/register";
    var headers = ds_map_create();
    ds_map_add(headers, "Content-Type", "application/x-www-form-urlencoded");

    var body = "username=" + url_encode(string(_username))
             + "&password=" + url_encode(string(_password));

    global.req_register = http_request(url, "POST", headers, body);
    show_debug_message("[HTTP] POST /register -> req_id: " + string(global.req_register));

    ds_map_destroy(headers);
}
