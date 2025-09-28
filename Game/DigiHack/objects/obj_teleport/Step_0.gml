if place_meeting(x, y ,obj_Player) && !instance_exists(obj_teleport_animation) {
    var inst = instance_create_depth(0,0, -9999, obj_teleport_animation);
    inst.target_x = target_x;
    inst.target_y = target_y;
    inst.target_rm = target_rm;
}