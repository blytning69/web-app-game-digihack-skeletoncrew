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
}

// Animate pause sprite
if (pause) {
    n = (n + 1) mod (max_frames + 1);
} else {
    n = 0;
}

// ====================
// Redeem Button Click
// ====================
if (pause) {
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);

    var bx = display_get_gui_width()/2;
    var by = display_get_gui_height()/2 + 20;

    if (global.points > 0) { // Only clickable if you have points
        if (mouse_check_button_pressed(mb_left)) {
            if (point_in_rectangle(mx, my, bx-100, by-20, bx+100, by+20)) {
                global.currency += global.points; 
                global.points = 0;
            }
        }
    }
}
