    var left     = keyboard_check_pressed(ord("A"));
    var right   = keyboard_check_pressed(ord("D"));
    var accept = keyboard_check_pressed(ord("E"));
    var back   = keyboard_check_pressed(ord("B"));

if right {
    image_index++;
}

if left {
    image_index--;
}

if image_index == 0 && accept {
    room_goto(Main_Menu);
    
}

if image_index == 1 {
    
}

if image_index == 2 {
    
}

if image_index == 3 {
    
}