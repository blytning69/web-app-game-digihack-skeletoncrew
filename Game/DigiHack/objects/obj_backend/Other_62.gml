var status = async_load[? "status"];
var result_str = async_load[? "result"];

if (is_string(result_str)) {
    var json;
    try { json = json_parse(result_str); } catch (e) { exit; }

    if (ds_map_exists(json, "access_token")) {
        global.access_token = json[? "access_token"];
        show_debug_message("Token Disimpan!" + global.access_token);
    }

    if (ds_map_exists(json, "msg")) {
        show_debug_message(json[? "msg"]);
    }

    if (ds_map_exists(json, "transactions")) {
        show_debug_message("Jumlah transaksi: " + string(array_length(json[? "transactions"])));
    }
}
