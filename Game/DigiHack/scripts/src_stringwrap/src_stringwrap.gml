/// @function string_wrap(_text, _width)
/// @param _text  : string yang mau dibungkus
/// @param _width : lebar maksimum per baris (dalam pixel)
function string_wrap(_text, _width) {
    var words = string_split(_text, " ");
    var line  = "";
    var out   = "";
    var fnt   = draw_get_font();
    
    for (var i = 0; i < array_length(words); i++) {
        var test_line = line;
        if (line != "") test_line += " ";
        test_line += words[i];
        
        if (string_width(test_line) > _width) {
            out += line + "\n";
            line = words[i];
        } else {
            line = test_line;
        }
    }
    out += line;
    return out;
}