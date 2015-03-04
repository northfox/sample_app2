$(document).ready(function() {
    $("#micropost_content").keyup(function() {
        var remainingChars = 140 - $(this).val().length;
        if(remainingChars < 0) {
            $("#remaining_chars").addClass("text-error");
            $("#remaining_chars").text((-1 * remainingChars) + " chars overwriting.");
        } else {
            $("#remaining_chars").removeClass("text-error");
            $("#remaining_chars").text(remainingChars + " chars remaining.");
        }
    });
});
