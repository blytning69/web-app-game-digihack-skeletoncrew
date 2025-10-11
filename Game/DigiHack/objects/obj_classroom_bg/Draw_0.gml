var _camx = camera_get_view_x(view_camera[0]);
var _camy = camera_get_view_y(view_camera[0]);
var _p = .2;
var frame = floor((current_time / 100) mod sprite_get_number(spr_bg_classroom));

draw_sprite_tiled(spr_bg_classroom, frame,  _camx * _p, _camy * _p);