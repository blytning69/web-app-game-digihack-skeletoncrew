var cam_ctrl = instance_find(obj_camera_classroom, 0);

if (instance_exists(cam_ctrl)) {
    if (!cam_ctrl.zoomed_out) {
        cam_ctrl.target_w = 640;
        cam_ctrl.target_h = 320;
        cam_ctrl.zoomed_out = true;
    } else {
        cam_ctrl.target_w = 320;
        cam_ctrl.target_h = 180;
        cam_ctrl.zoomed_out = false;
    }
}