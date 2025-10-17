/// @desc Step Event for Login Page

if (!typing_mode) {

    
    keyboard_string = "";

    // Movement & control keys
    var up     = keyboard_check_pressed(ord("W"));
    var down   = keyboard_check_pressed(ord("S"));
    var accept = keyboard_check_pressed(ord("E"));
    var back   = keyboard_check_pressed(ord("B"));

    // Navigate between menu options
    if (up)   image_index--;
    if (down) image_index++;

    // Wrap around menu indexes (0–4)
    if (image_index < 0) image_index = 4;
    if (image_index > 4) image_index = 0;

    // -------------------------------
    // Jika sudah login, langsung ke rm_redeem
    // -------------------------------
    if (global.sign_in && room != rm_redeem) {
    room_goto(rm_redeem);
    exit;
}

    // -------------------------------
    // When "Accept" (E) is pressed
    // -------------------------------
    if (accept) {
        switch (image_index) {

            case 0:
                // Return to main menu
                room_goto(Main_Menu);
                break;

            case 1:
                // Focus username input
                typing_mode  = true;
                active_field = 0;
                keyboard_string = username;
                break;

            case 2:
                // Focus password input
                typing_mode  = true;
                active_field = 1;
                keyboard_string = password;
                break;

            case 3:
                // ---------------- LOGIN ----------------
                show_debug_message("Sign In pressed!");
                show_debug_message("Username: " + username);
                show_debug_message("Password: " + password);

                // Panggil fungsi login
                login_user(username, password);

                // Simpan status login
                global.sign_in = true;

                // Pindah ke halaman berikut
                room_goto(rm_redeem);
                break;

            case 4:
                // ---------------- REGISTER ----------------
                show_debug_message("Sign Up pressed!");
                show_debug_message("Username: " + username);
                show_debug_message("Password: " + password);

                register_user(username, password);
                room_goto(Main_Menu);
                break;
        }
    }

} else {
    if (active_field == 0) username = keyboard_string;
    if (active_field == 1) password = keyboard_string;

    
    if (keyboard_check_pressed(vk_enter)) {
        typing_mode   = false;
        active_field  = -1;
        keyboard_string = "";
    }

    // Optional: Press B → cancel typing
    if (keyboard_check_pressed(ord("B"))) {
        typing_mode   = false;
        active_field  = -1;
        keyboard_string = "";
    }
}
