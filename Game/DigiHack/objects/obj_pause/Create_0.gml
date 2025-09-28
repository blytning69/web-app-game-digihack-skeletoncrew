pause = false;                // Game starts unpaused
pauseSurf = -1;               // Pause overlay surface
pauseSurfBuffer = -1;         // Secondary surface (unused but ready)
resW = 1366;                  // Resolution width
resH = 768;                   // Resolution height

menu_alpha = 0;               // Current fade opacity
menu_target_alpha = 0;        // Target opacity (0 or 1)
menu_fade_speed = 0.1;        // How fast fade happens
n = 0;                        // Frame index for pause sprite animation
spr_resume = spr_pause;       // Sprite for pause menu (fallback: same as spr_pause)
max_frames = sprite_get_number(spr_pause) - 1; // Frames in pause sprite
