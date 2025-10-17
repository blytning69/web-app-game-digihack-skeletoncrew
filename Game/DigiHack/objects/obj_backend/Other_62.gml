/// @desc Async HTTP Event handler for all API calls
var status  = async_load[? "status"];
var req_id  = async_load[? "id"];        // renamed from 'id' → 'req_id'
var result  = async_load[? "result"];

show_debug_message("[HTTP-ASYNC] req_id=" + string(req_id) + " status=" + string(status));

if (status == 0) {
    show_debug_message("❌ HTTP failed or aborted (status 0).");
    exit;
}

if (!is_string(result)) {
    // Some platforms could give a buffer; try soft-fail.
    show_debug_message("⚠️ Result is not a string; cannot parse.");
    exit;
}

show_debug_message("↩ Raw: " + result);

// ---------- Parse JSON safely ----------
var json = undefined;
try {
    json = json_parse(result); // returns ds_map / ds_list trees
} catch (e) {
    show_debug_message("❌ JSON parse error: " + string(e));
    exit;
}

// ---------- Helper ----------
var function __get_or__(map, key, fallback) {
    return ds_map_exists(map, key) ? map[? key] : fallback;
};

// ---------- Handle each request ----------
if (variable_global_exists("req_login") && req_id == global.req_login) {
    // Expect: { access_token, token_type }
    if (ds_map_exists(json, "access_token")) {
        global.access_token = json[? "access_token"];
        show_debug_message("✅ Logged in. Token stored.");
        global.is_logged_in = true;
    } else {
        var detail = __get_or__(json, "detail", "Login failed");
        show_debug_message("❌ Login error: " + string(detail));
        global.is_logged_in = false;
    }
}

if (variable_global_exists("req_register") && req_id == global.req_register) {
    var msg = __get_or__(json, "msg", "Register response received.");
    show_debug_message("🆕 " + string(msg));
}

if (variable_global_exists("req_tx") && req_id == global.req_tx) {
    if (ds_map_exists(json, "transactions")) {
        var txs = json[? "transactions"]; // usually a ds_list
        var count = 0;
        if (is_ds_list(txs)) count = ds_list_size(txs);
        show_debug_message("🧾 Transactions count: " + string(count));
    } else {
        show_debug_message("⚠️ No 'transactions' key in response.");
    }
}

if (variable_global_exists("req_redeem") && req_id == global.req_redeem) {
    var msg = __get_or__(json, "msg", "Redeem response received.");
    show_debug_message("💸 Redeem: " + string(msg));
}

if (variable_global_exists("req_link") && req_id == global.req_link) {
    var msg = __get_or__(json, "msg", "Link payment response received.");
    show_debug_message("🔗 " + string(msg));
}

// ---------- Generic detail fallback ----------
if (ds_map_exists(json, "detail")) {
    var d = json[? "detail"];
    if (is_string(d)) show_debug_message("⚠️ detail: " + d);
    else show_debug_message("⚠️ 'detail' present (non-string). Inspect raw above.");
}

// ---------- Cleanup ----------
ds_map_destroy(json);
