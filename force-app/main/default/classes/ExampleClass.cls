public class ExampleClass {
    public static void exampleMethod() {
        Map<String, List<String>> mapofList = new Map<String, List<String>>();
        mapofList.put('Key1', new List<String>());
        mapofList.get('Key1').add('ListValue11');
        mapofList.get('Key1').add('ListValue12');
        mapofList.put('Key2', new List<String>());
        mapofList.get('Key2').add('ListValue21');
        mapofList.get('Key2').add('ListValue22');
        
        for (String var : mapofList.keySet()) {
            for (String str : mapofList.get(var)) {
                System.debug('Key - '+var+' '+'Value - '+str);
            }
        }
    }
}