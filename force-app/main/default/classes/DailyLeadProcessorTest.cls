@isTest
public class DailyLeadProcessorTest {
    
    @isTest
    public static void testing() {
        
        List<lead> l_lst = new List<lead>();
        for(Integer i=0;i<200;i++) {
            lead l = new lead();
            l.lastname = 'lastname'+i;
            l.Company = 'company'+i;
            l_lst.add(l);
        }
        insert l_lst;
        
        Test.startTest();
        DailyLeadProcessor dlp = new DailyLeadProcessor ();
        String jobId = System.Schedule('dailyleadprocessing','0 0 0 1 12 ? 2018',dlp);
        Test.stopTest();
        
        List<lead> l_lst_chk = new List<lead>([select id,leadsource from lead where leadsource != 'Dreamforce']);
        System.assertequals(0,l_lst_chk.size());
    }

}