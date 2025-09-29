// Toggle pause with ESC
if (keyboard_check_pressed(vk_escape)) {
    // if help is open, ESC closes it instead of pausing
    if (global.show_help) {
        global.show_help = false;
    } else {
        pause = !pause;
        if (pause) {
            menu_target_alpha = 1;
        } else {
            menu_target_alpha = 0;
        }
    }
}

// Smooth fade
if (menu_alpha < menu_target_alpha) {
    menu_alpha = min(menu_alpha + menu_fade_speed, menu_target_alpha);
} else if (menu_alpha > menu_target_alpha) {
    menu_alpha = max(menu_alpha - menu_fade_speed, menu_target_alpha);

    if (menu_alpha == 0 && pause_action == "menu") {
        room_goto(Main_Menu);
        pause_action = "";
    }
}

// While paused
if (pause && !global.show_help) {  // only show menu if not inside help
    var cx = display_get_gui_width()/2;
    var cy = display_get_gui_height()/2 - 40;
    var spr_w = sprite_get_width(spr_pause);
    var spr_h = sprite_get_height(spr_pause);

    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);

    // Keyboard nav
    if (keyboard_check_pressed(vk_up))   image_index = max(0, image_index - 1);
    if (keyboard_check_pressed(vk_down)) image_index = min(3, image_index + 1);

    // Mouse hover (split sprite vertically)
    var zone_h = spr_h / 4;
    if (point_in_rectangle(mx, my, cx - spr_w/2, cy - spr_h/2, cx + spr_w/2, cy - spr_h/2 + zone_h)) image_index = 0;
    if (point_in_rectangle(mx, my, cx - spr_w/2, cy - spr_h/2 + zone_h, cx + spr_w/2, cy - spr_h/2 + zone_h*2)) image_index = 1;
    if (point_in_rectangle(mx, my, cx - spr_w/2, cy - spr_h/2 + zone_h*2, cx + spr_w/2, cy - spr_h/2 + zone_h*3)) image_index = 2;
    if (point_in_rectangle(mx, my, cx - spr_w/2, cy - spr_h/2 + zone_h*3, cx + spr_w/2, cy - spr_h/2 + zone_h*4)) image_index = 3;

    // Confirm
    if (keyboard_check_pressed(vk_enter) || mouse_check_button_pressed(mb_left)) {
        if (image_index == 0) { // Resume
            pause = false;
            menu_target_alpha = 0;
            pause_action = "resume";
        }
        else if (image_index == 1) { // Main Menu
            menu_target_alpha = 0;
            pause_action = "menu";
        }
        else if (image_index == 2) { // Help
            global.show_help = true; 
        }
        else if (image_index == 3) { // Redeem
            if (global.points > 0) {
                global.currency += global.points;
                global.points = 0;
            }
        }
    }
}
