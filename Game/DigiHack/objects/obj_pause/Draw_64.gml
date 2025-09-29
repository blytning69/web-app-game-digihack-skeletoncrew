if (pause || menu_alpha > 0) {
    var gw = display_get_gui_width();
    var gh = display_get_gui_height();
    var cx = gw/2;
    var cy = gh/2;

    // Dark overlay
    draw_set_alpha(menu_alpha * 0.5);
    draw_set_color(c_black);
    draw_rectangle(0, 0, gw, gh, false);

    // Draw pause sprite (frame 0 or 1)
    draw_set_alpha(menu_alpha);
    draw_sprite(spr_pause, image_index, cx, cy - 40);

    // Redeem button
    var bx = cx;
    var by = cy + sprite_get_height(spr_pause)/2 + 40;

    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);

    var hovered = point_in_rectangle(mx, my, bx-100, by-20, bx+100, by+20);

    if (global.points > 0) {
        draw_set_color(hovered ? c_orange : c_yellow);
    } else {
        draw_set_color(c_gray);
    }
    draw_rectangle(bx-100, by-20, bx+100, by+20, false);

    draw_set_color(c_black);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(bx, by, "[ Redeem Points ]");

    // Reset
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
