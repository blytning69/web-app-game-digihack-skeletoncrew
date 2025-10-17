if (!typing_mode) {
    
    keyboard_string = "";

    var up = keyboard_check_pressed(ord("W"));
    var down = keyboard_check_pressed(ord("S"));
    var accept = keyboard_check_pressed(ord("E"));
    var back = keyboard_check_pressed(ord("B"));

    if (up) image_index--;
    if (down) image_index++;

    if (image_index < 0) image_index = 3;
    if (image_index > 3) image_index = 0;


    if (accept) {
        switch (image_index) {
            case 0: 
                room_goto(Main_Menu); 
                break;

            case 1: 
                typing_mode = true;
                active_field = 0;
                keyboard_string = username;
                break;

            case 2: 
                typing_mode = true;
                active_field = 1;
                keyboard_string = password;
                break;

            case 3: 
                show_debug_message("Sign Up pressed!");
                show_debug_message("Username: " + username);
                show_debug_message("Password: " + password);
                room_goto(rm_login);
                break;
        }
    }
}



else {
    if (active_field == 0) username = keyboard_string;
    if (active_field == 1) password = keyboard_string;

    if (keyboard_check_pressed(vk_enter)) {
        typing_mode = false;
        active_field = -1;
        keyboard_string = ""; 
    }
}
