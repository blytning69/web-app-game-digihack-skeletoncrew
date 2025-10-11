// ============================
// Stop all logic if paused or in dialogue
// ============================
if (obj_pause.pause || global.in_dialogue) {
    // freeze animation frame when paused or in dialogue
    image_speed = 0;
    exit; 
} else {
    image_speed = 1; // allow animation when not paused
}

// ============================
// Movement input
// ============================
move_right = keyboard_check(ord("D"));
move_left  = keyboard_check(ord("A"));
move_up    = keyboard_check(ord("W"));
move_down  = keyboard_check(ord("S"));

xspd = (move_right - move_left) * move_spd;
yspd = (move_down - move_up) * move_spd;

// ============================
// Sprite facing & animation
// ============================
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

// ============================
// Collision detection
// ============================
if place_meeting(x + xspd, y, obj_wall) {
    xspd = 0;
}
if place_meeting(x, y + yspd, obj_wall) {
    yspd = 0;
}
x += xspd;
y += yspd;


// ============================
// Facing direction
// ============================
if xspd != 0 || yspd != 0 {
    if (xspd > 0)  face = "right";
    if (xspd < 0)  face = "left";
    if (yspd > 0)  face = "down";
    if (yspd < 0)  face = "up";
}

// ============================
// Idle animation frame reset
// ============================
if xspd == 0 && yspd == 0 {
    image_index = 0;
}

// ============================
// Depth sorting
// ============================
depth = -bbox_bottom;
