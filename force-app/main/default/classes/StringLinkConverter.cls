public class StringLinkConverter {
	public static String convertURLsToLinks(String text) {
        if (String.isBlank(text)) {
            return text;
        }
        String regEx = '(.?|\\A|\\s)((http|https|ftp|mailto)(:\\/\\/)([^/< ]+)(\\/[^ ]+)?)(.?|\\s|\\z)';
        String anchorTag = '$1<a href=\"$2\">$3$4$5...</a>$7';
        return text.replaceAll(regEx,anchorTag);
    }
}