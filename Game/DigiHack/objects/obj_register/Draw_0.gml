draw_self(); 

draw_set_color(c_white);


if (image_index == 1) {
    if (typing_mode && active_field == 0) draw_set_color(c_black);
        else draw_set_color(c_gray);
} else draw_set_color(c_white);
draw_text(353, 323, username + ((typing_mode && active_field == 0 && (current_time div 500) mod 2 == 0) ? "|" : ""));


if (image_index == 2) {
    if (typing_mode && active_field == 1) draw_set_color(c_black);
        else draw_set_color(c_gray);
} else draw_set_color(c_white);
var hidden_pass = string_repeat("*", string_length(password));
draw_text(353, 380, hidden_pass + ((typing_mode && active_field == 1 && (current_time div 500) mod 2 == 0) ? "|" : ""));
