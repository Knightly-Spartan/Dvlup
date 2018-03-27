@isTest
public class StringLinkConverterTest {
    @isTest public static void testURLToLinkConverter() {
        String sampleText = 'Lorem ipsum dolor sit amet http://www.bing.com consectetur adipiscing mailto://mail@example.com elit sed http://www.google.com/search do eiusmod tempor incididunt ut labore et dolore magna aliqua.';
        String resultText = StringLinkConverter.convertURLsToLinks(sampleText);
        System.debug('Result '+resultText);
    }
}