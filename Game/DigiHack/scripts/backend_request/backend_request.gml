/// @section Helpers

function __ensure_base_url__() {
    if (!variable_global_exists("API_BASE_URL")) {
        global.API_BASE_URL = "https://web-app-game-digihack-skeletoncrew.onrender.com";
    }
}

function __add_auth__(headers_map) {
    if (variable_global_exists("access_token") && is_string(global.access_token) && global.access_token != "") {
        ds_map_add(headers_map, "Authorization", "Bearer " + global.access_token);
        return true;
    }
    show_debug_message("⚠️ No access_token set. Did you /login first?");
    return false;
}

/// @func get_transactions()
function get_transactions() {
    __ensure_base_url__();

    var url = global.API_BASE_URL + "/transactions";
    var headers = ds_map_create();
    __add_auth__(headers);

    global.req_tx = http_request(url, "GET", headers, "");
    show_debug_message("[HTTP] GET /transactions -> req_id: " + string(global.req_tx));

    ds_map_destroy(headers);
}

/// @func link_payment(_method)
function link_payment(_method) {
    __ensure_base_url__();

    var url = global.API_BASE_URL + "/link_payment?method=" + string(_method);
    var headers = ds_map_create();
    __add_auth__(headers);

    global.req_link = http_request(url, "POST", headers, "");
    show_debug_message("[HTTP] POST /link_payment?method=" + string(_method) + " -> req_id: " + string(global.req_link));

    ds_map_destroy(headers);
}

/// @func redeem_points(_amount, _account_number, _account_holder_name, _bank_code)
function redeem_points(_amount, _account_number, _account_holder_name, _bank_code) {
    __ensure_base_url__();

    var url = global.API_BASE_URL + "/redeem";
    var headers = ds_map_create();
    ds_map_add(headers, "Content-Type", "application/json");
    __add_auth__(headers);

    var body_map = ds_map_create();
    if (!is_undefined(_amount))              ds_map_add(body_map, "amount", real(_amount));
    if (!is_undefined(_account_number))      ds_map_add(body_map, "account_number", string(_account_number));
    if (!is_undefined(_account_holder_name)) ds_map_add(body_map, "account_holder_name", string(_account_holder_name));
    if (!is_undefined(_bank_code))           ds_map_add(body_map, "bank_code", string(_bank_code));

    var body_json = json_encode(body_map);

    var buf = buffer_create(string_byte_length(body_json) + 1, buffer_fixed, 1);
    buffer_write(buf, buffer_text, body_json);
    buffer_seek(buf, buffer_seek_start, 0);

    // Versi baru: (url, method, data-buffer, headers)
    global.req_redeem = http_request(url, "POST", buf, headers);
    show_debug_message("[HTTP] POST /redeem -> req_id: " + string(global.req_redeem) + " body=" + body_json);

    buffer_delete(buf);
    ds_map_destroy(body_map);
    ds_map_destroy(headers);
}


