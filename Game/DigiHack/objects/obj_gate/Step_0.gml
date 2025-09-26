if !quest_done {
    image_index = 0;
    image_speed = 0;
} else {
    if (image_index < image_number - 1) {
        image_speed = 0.5;
    } else {
        image_index = image_number - 1
        image_speed = 0;
    }
}
