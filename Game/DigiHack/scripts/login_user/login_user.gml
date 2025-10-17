/// @func login_user(_username, _password)


/// @desc POST /login using x-www-form-urlencoded; stores request id in global.req_login
/// @func url_encode(str)
/// @desc Encodes a string so it can safely appear in a URL query or x-www-form-urlencoded body.
function url_encode(_str) {
    var s = string(_str);
    // Replace common special characters with their percent-encoded form
    s = string_replace_all(s, " ", "%20");
    s = string_replace_all(s, "!", "%21");
    s = string_replace_all(s, "#", "%23");
    s = string_replace_all(s, "$", "%24");
    s = string_replace_all(s, "&", "%26");
    s = string_replace_all(s, "'", "%27");
    s = string_replace_all(s, "(", "%28");
    s = string_replace_all(s, ")", "%29");
    s = string_replace_all(s, "*", "%2A");
    s = string_replace_all(s, "+", "%2B");
    s = string_replace_all(s, ",", "%2C");
    s = string_replace_all(s, "/", "%2F");
    s = string_replace_all(s, ":", "%3A");
    s = string_replace_all(s, ";", "%3B");
    s = string_replace_all(s, "=", "%3D");
    s = string_replace_all(s, "?", "%3F");
    s = string_replace_all(s, "@", "%40");
    s = string_replace_all(s, "[", "%5B");
    s = string_replace_all(s, "]", "%5D");
    return s;
}


function login_user(_username, _password) {
    if (!variable_global_exists("API_BASE_URL")) {
        global.API_BASE_URL = "https://web-app-game-digihack-skeletoncrew.onrender.com";
    }

    var url = global.API_BASE_URL + "/login";
    var headers = ds_map_create();
    ds_map_add(headers, "Content-Type", "application/x-www-form-urlencoded");

    var body = "username=" + url_encode(string(_username))
             + "&password=" + url_encode(string(_password));

    global.req_login = http_request(url, "POST", headers, body);
    show_debug_message("[HTTP] POST /login -> req_id: " + string(global.req_login));

    ds_map_destroy(headers);
}
