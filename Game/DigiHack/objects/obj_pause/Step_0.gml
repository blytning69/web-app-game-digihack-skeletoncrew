
up_key = keyboard_check_pressed(vk_up);
down_key = keyboard_check_pressed(vk_down);
enter = keyboard_check_pressed(ord("E"));




if (keyboard_check_pressed(vk_escape)) {
    if (!pause) {

        pause = true;
        menu_target_alpha = 1;
        
        instance_deactivate_all(true);
        

        pauseSurf = surface_create(resW, resH);
        surface_set_target(pauseSurf);
            draw_surface(application_surface, 0, 0);
        surface_reset_target();
        

        if (buffer_exists(pauseSurfBuffer)) buffer_delete(pauseSurfBuffer);
        pauseSurfBuffer = buffer_create(resW * resH * 4, buffer_fixed, 1);
        buffer_get_surface(pauseSurfBuffer, pauseSurf, 0);
    }
    else {

        pause = false;
        menu_target_alpha = 0;
        menu_alpha = 0;
        
        instance_activate_all();
        
        if (surface_exists(pauseSurf)) surface_free(pauseSurf);
        if (buffer_exists(pauseSurfBuffer)) buffer_delete(pauseSurfBuffer);
        
        pauseSurf = -1;
        pauseSurfBuffer = -1;
    }
}