gpu_get_blendenable();

if (pause) {

    surface_set_target(application_surface);
    if (surface_exists(pauseSurf)) {
        draw_surface(pauseSurf, 0, 0);
    } else {
        pauseSurf = surface_create(resW, resH);
        buffer_set_surface(pauseSurfBuffer, pauseSurf, 0);
    }
    surface_reset_target();
    
    menu_alpha = lerp(menu_alpha, menu_target_alpha, menu_fade_speed);
    

    if (menu_alpha > 0) {

        var menu_sprite = spr_pause; 
        

        var center_x = resW / 2;
        var center_y = resH / 2;
        

        draw_set_alpha(menu_alpha * 0.7);
        draw_set_color(c_black);
        draw_rectangle(0, 0, resW, resH, false);
        

        draw_set_alpha(menu_alpha);
        draw_set_color(c_white);
        
        
        if up_key {
            n--;
            if (n < 0) {
                n = max_frames;
            }
        }

        if down_key {
            n++;
            if n > max_frames {
                n = 0;
            }
        }
        
        if (sprite_get_number(spr_pause) - 1) == 1 && enter {
            room_goto(Main_Menu);
        }
        draw_sprite(spr_resume, n, 0, 0);
        
        draw_set_alpha(1);
    }
}