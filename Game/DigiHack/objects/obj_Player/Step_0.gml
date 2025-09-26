move_right = keyboard_check(ord("D"));
move_left = keyboard_check(ord("A"));
move_up = keyboard_check(ord("W"));
move_down = keyboard_check(ord("S"));

xspd = (move_right - move_left) * move_spd;
yspd = (move_down - move_up) * move_spd;

switch (face) {
    case "right":
        sprite_index = (xspd != 0 || yspd != 0) ? Player_sprite_right_walk : Player_sprite_right_walk_idle;
        break;
    case "left":
        sprite_index = (xspd != 0 || yspd != 0) ? Player_sprite_left_walk : Player_sprite_left_idle;
        break;
    case "up":
        sprite_index = (xspd != 0 || yspd != 0) ? Player_sprite_back_walk : Player_sprite_back_idle;
        break;
    case "down":
        sprite_index = (xspd != 0 || yspd != 0) ? Player_sprite_walk_up : Player_sprite_idle_up;
        break;
}
mask_index = Player_sprite_idle_up;

if place_meeting(x + xspd, y, obj_wall) {
    xspd = 0;
}
if place_meeting(x, y + yspd, obj_wall) {
    yspd = 0;
}
x += xspd;
y += yspd;



if xspd != 0 || yspd != 0 {
    if (xspd > 0) {
        face = "right";
    }
    if (xspd < 0) {
        face = "left";
    }
    if (yspd > 0) {
        face = "down";
    }
    if (yspd < 0) {
        face = "up";
    }
}



if xspd = 0 && yspd == 0 {
    image_index = 0;
}



depth = -bbox_bottom;



