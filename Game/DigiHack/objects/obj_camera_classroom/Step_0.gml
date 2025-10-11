// --- pastikan player dan kamera aktif ---
if (!instance_exists(obj_Player)) exit;

// --- toggle zoom sekali ---
if (place_meeting(obj_Player.x, obj_Player.y, obj_zoom_trigger)) {
    if (can_toggle) {               // hanya pertama kali nabrak
        zoomed_out = !zoomed_out;   // ubah state
        can_toggle = false;         // kunci biar gak spam
    }
} else {
    can_toggle = true;              // reset setelah keluar area
}

// --- tentukan ukuran kamera berdasarkan state ---
if (zoomed_out) {
    target_w = 640;
    target_h = 320;
} else {
    target_w = 320;
    target_h = 180;
}

// --- transisi halus ---
view_w = lerp(view_w, target_w, 0.1);
view_h = lerp(view_h, target_h, 0.1);

// --- update kamera ---
camera_set_view_size(view_camera[0], view_w, view_h);
camera_set_view_pos(view_camera[0],
    obj_Player.x - view_w / 2,
    obj_Player.y - view_h / 2);