/// @section Backend API Wrappers
/// Fungsi-fungsi ini memanggil backend_request() dengan parameter yang sesuai.
/// Format: backend_request(endpoint, method, data, require_auth)

function register_user(u, p) {
    var data = "username=" + string(u) + "&password=" + string(p);
    backend_request("register", "POST", data, false);
}

function login_user(u, p) {
    var data = "username=" + string(u) + "&password=" + string(p);
    backend_request("login", "POST", data, false);
}

function link_gopay() {
    backend_request("link_payment?method=gopay", "POST", "", true);
}

function link_card() {
    backend_request("link_payment?method=card", "POST", "", true);
}

function get_balance() {
    backend_request("transactions", "GET", "", true);
}


