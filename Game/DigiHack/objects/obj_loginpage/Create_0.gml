/// @desc Initialize Login Page variables

username = "";
password = "";
active_field = -1;
show_password = false;
typing_mode = false;
image_speed = 0;
if (!variable_global_exists("sign_in")) {
    global.sign_in = false;
}
