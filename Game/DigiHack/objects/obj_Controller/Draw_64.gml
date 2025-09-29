if (instance_exists(obj_pause) && (obj_pause.pause || obj_pause.menu_alpha > 0)) {
    var gw = display_get_gui_width();
    var gh = display_get_gui_height();
    var cx = gw / 2;
    var cy = gh / 2;

    // --- Dark overlay ---
    draw_set_alpha(obj_pause.menu_alpha * 0.5);
    draw_set_color(c_black);
    draw_rectangle(0, 0, gw, gh, false);

    if (global.show_help) {
        // --- Help Page ---
        draw_set_alpha(1);
        draw_sprite(spr_help_page, 0, cx, cy);

        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_white);
        draw_text(cx, gh - 40, "Press ESC to return");
    }
    else {
        // --- Pause menu sprite ---
        draw_set_alpha(obj_pause.menu_alpha);
        draw_sprite(spr_pause, obj_pause.image_index, cx, cy - 40);

        // --- Stats: Points & Currency ---
        draw_set_alpha(1);
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);

        // POINTS N CURRENCY TEXT UNDER
        var stats_y = (cy - 40) + sprite_get_height(spr_pause)/2 - 10;

        draw_text(cx, stats_y,       "Points: "   + string(global.points));
        draw_text(cx, stats_y + 18,  "Currency: " + string(global.currency));
    }

    // --- Reset draw state ---
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
