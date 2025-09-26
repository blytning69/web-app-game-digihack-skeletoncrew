/// @function url_encode(_str)
/// @desc Encodes a string for safe use in a URL query, including math symbols
/// @param _str The raw string
function url_encode(_str) {
    var s = _str;

    // Encode % first
    s = string_replace_all(s, "%", "%25");

    // Common reserved characters
    s = string_replace_all(s, " ", "%20");
    s = string_replace_all(s, "!", "%21");
    s = string_replace_all(s, "\"", "%22");
    s = string_replace_all(s, "#", "%23");
    s = string_replace_all(s, "$", "%24");
    s = string_replace_all(s, "&", "%26");
    s = string_replace_all(s, "'", "%27");
    s = string_replace_all(s, "(", "%28");
    s = string_replace_all(s, ")", "%29");
    s = string_replace_all(s, "*", "%2A");
    s = string_replace_all(s, "+", "%2B");
    s = string_replace_all(s, ",", "%2C");
    s = string_replace_all(s, "-", "%2D");
    s = string_replace_all(s, ".", "%2E");
    s = string_replace_all(s, "/", "%2F");
    s = string_replace_all(s, ":", "%3A");
    s = string_replace_all(s, ";", "%3B");
    s = string_replace_all(s, "<", "%3C");
    s = string_replace_all(s, "=", "%3D");
    s = string_replace_all(s, ">", "%3E");
    s = string_replace_all(s, "?", "%3F");
    s = string_replace_all(s, "@", "%40");
    s = string_replace_all(s, "[", "%5B");
    s = string_replace_all(s, "\\", "%5C");
    s = string_replace_all(s, "]", "%5D");
    s = string_replace_all(s, "^", "%5E");
    s = string_replace_all(s, "_", "%5F");
    s = string_replace_all(s, "`", "%60");
    s = string_replace_all(s, "{", "%7B");
    s = string_replace_all(s, "|", "%7C");
    s = string_replace_all(s, "}", "%7D");
    s = string_replace_all(s, "~", "%7E");

    // --- Math symbols ---
    s = string_replace_all(s, "+", "%2B");  // plus
    s = string_replace_all(s, "-", "%2D");  // minus
    s = string_replace_all(s, "×", "%C3%97"); // multiplication sign
    s = string_replace_all(s, "*", "%2A");  // asterisk
    s = string_replace_all(s, "÷", "%C3%B7"); // division sign
    s = string_replace_all(s, "/", "%2F");  // slash
    s = string_replace_all(s, "√", "%E2%88%9A"); // square root
    s = string_replace_all(s, "±", "%C2%B1"); // plus/minus
    s = string_replace_all(s, "=", "%3D");  // equals
    s = string_replace_all(s, "^", "%5E");  // power
    s = string_replace_all(s, "π", "%CF%80"); // pi
    s = string_replace_all(s, "∞", "%E2%88%9E"); // infinity
    s = string_replace_all(s, "<", "%3C");  // less than
    s = string_replace_all(s, ">", "%3E");  // greater than
    s = string_replace_all(s, "≤", "%E2%89%A4"); // less or equal
    s = string_replace_all(s, "≥", "%E2%89%A5"); // greater or equal
    s = string_replace_all(s, "≠", "%E2%89%A0"); // not equal
    s = string_replace_all(s, "≈", "%E2%89%88"); // approximately equal
    s = string_replace_all(s, "∑", "%E2%88%91"); // summation
    s = string_replace_all(s, "∫", "%E2%88%AB"); // integral
    s = string_replace_all(s, "∆", "%E2%88%86"); // delta
    s = string_replace_all(s, "∂", "%E2%88%82"); // partial derivative

    return s;
}