/// @function scr_add_text_pages(_text)
/// @desc Wraps and splits text into multiple pages that fit inside the textbox.
/// @param _text The text string to add as pages
function scr_add_text_pages(_text) {
    // Word wrap based on textbox line width
    var wrapped = string_wrap(_text, line_width);

    // Split into lines
    var lines = string_split(wrapped, "\n");

    // How many lines fit in one textbox page
    var lines_per_page = floor((textbox_height - border*2) / line_sep);

    var buffer = "";

    for (var i = 0; i < array_length(lines); i++) {
        buffer += lines[i] + "\n";

        // If page is full OR last line → save page
        if (((i + 1) mod lines_per_page) == 0 || i == array_length(lines) - 1) {
            text[page_number] = buffer;
            text_length[page_number] = string_length(buffer);
            page_number++;
            buffer = "";
        }
    }
}