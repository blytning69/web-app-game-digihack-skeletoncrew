// Toggle pause with ESC
if (keyboard_check_pressed(vk_escape)) {
    pause = !pause;
    if (pause) {
        menu_target_alpha = 1; // fade in
    } else {
        menu_target_alpha = 0; // fade out
    }
}

// Smooth fade
if (menu_alpha < menu_target_alpha) {
    menu_alpha = min(menu_alpha + menu_fade_speed, menu_target_alpha);
} else if (menu_alpha > menu_target_alpha) {
    menu_alpha = max(menu_alpha - menu_fade_speed, menu_target_alpha);

    // ✅ If we were fading out to menu, change room once fade done
    if (menu_alpha == 0 && pause_action == "menu") {
        room_goto(Main_Menu);
        pause_action = ""; // reset
    }
}

// While paused
if (pause) {
    var cx = display_get_gui_width()/2;
    var cy = display_get_gui_height()/2 - 40;
    var spr_w = sprite_get_width(spr_pause);
    var spr_h = sprite_get_height(spr_pause);

    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);

    // Keyboard nav
    if (keyboard_check_pressed(vk_up))  image_index = 0;
    if (keyboard_check_pressed(vk_down)) image_index = 1;

    // Mouse hover
    if (point_in_rectangle(mx, my, cx - spr_w/2, cy - spr_h/2, cx + spr_w/2, cy)) {
        image_index = 0; // Resume
    }
    if (point_in_rectangle(mx, my, cx - spr_w/2, cy, cx + spr_w/2, cy + spr_h/2)) {
        image_index = 1; // Menu
    }

    // Confirm (Enter or Left Click)
    if (keyboard_check_pressed(vk_enter) || mouse_check_button_pressed(mb_left)) {
        if (image_index == 0) {
            pause = false;
            menu_target_alpha = 0;     // fade out
            pause_action = "resume";   // flag
        }
        else if (image_index == 1) {
            menu_target_alpha = 0;     // fade out
            pause_action = "menu";     // flag, room_goto happens after fade
        }
    }

    // Redeem button click
    var bx = display_get_gui_width()/2;
    var by = cy + spr_h/2 + 40;
    if (global.points > 0 && mouse_check_button_pressed(mb_left)) {
        if (point_in_rectangle(mx, my, bx-100, by-20, bx+100, by+20)) {
            global.currency += global.points;
            global.points = 0;
        }
    }
}
