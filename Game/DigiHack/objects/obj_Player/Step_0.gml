move_right = keyboard_check(ord("D"));
move_left = keyboard_check(ord("A"));
move_up = keyboard_check(ord("W"));
move_down = keyboard_check(ord("S"));

xspd = (move_right - move_left) * move_spd;
yspd = (move_down - move_up) * move_spd;


x += xspd;
y += yspd;

mask_index = sprite[UP];
if yspd == 0 {
    if (xspd > 0) {
        face = RIGHT;
    }else if (xspd < 0) {
        face = LEFT;
    }
}
if (xspd > 0 && face == LEFT) {
    face = RIGHT;
}
if (xspd < 0 && face == RIGHT) {
    face = LEFT;
}

if (xspd == 0) {
    if (yspd > 0) {
        face = DOWN;
    } else if (yspd < 0) {
        face = UP;
    }
}   
sprite_index = sprite[face]; 

if xspd == 0 && yspd == 0 {
    image_index = 0;
}


