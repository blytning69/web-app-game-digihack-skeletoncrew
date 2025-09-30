var up, down, accept, back;

up = keyboard_check_pressed(ord("W"));
down = keyboard_check_pressed(ord("S"));
accept = keyboard_check_pressed(ord("E"));
back = keyboard_check_pressed(ord("B"));


if up {
    image_index--;
}

if down {
    image_index++;
}

if image_index = 1 and accept {
    game_end();
}

if image_index = 0 and accept {
    room_goto(rm_maze_easy);
}