function register_user(u, p) {
    backend_request("register?username=" + u + "&password=" + p, "POST", "", false);
}

function login_user(u, p) {
    backend_request("login", "POST", "username=" + u + "&password=" + p, false);
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

function redeem_points() {
    backend_request("redeem", "POST", "", true);
}

