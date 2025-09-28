if (pause || menu_alpha > 0) {
    // Dark overlay
    draw_set_alpha(menu_alpha * 0.5);
    draw_set_color(c_black);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);

    // Pause sprite
    draw_set_alpha(menu_alpha);
    draw_sprite(spr_resume, n, display_get_gui_width()/2, display_get_gui_height()/2);

    // Centered text
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    // Title
    draw_set_color(c_white);
    draw_text(display_get_gui_width()/2, display_get_gui_height()/2 - 150, "PAUSED");

    // Stats
    draw_text(display_get_gui_width()/2, display_get_gui_height()/2 - 80, "Points: " + string(global.points));
    draw_text(display_get_gui_width()/2, display_get_gui_height()/2 - 40, "Currency: " + string(global.currency));

    // Redeem button position
    var bx = display_get_gui_width()/2;
    var by = display_get_gui_height()/2 + 20;

    // Mouse in GUI space
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);

    // Check hover
    var hovered = point_in_rectangle(mx, my, bx-100, by-20, bx+100, by+20);

    // Button color logic
    if (global.points > 0) {
        draw_set_color(hovered ? c_orange : c_yellow);
    } else {
        draw_set_color(c_gray); // disabled
    }

    // Draw redeem button
    draw_text(bx, by, "[ Redeem Points ]");

// Reset draw state to defaults
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1); // resets 
}
