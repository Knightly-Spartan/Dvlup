public class JEAuctionController{
    public String Bidder_Name{set;get;}
    public String Bidder_Email{set;get;}
    public Boolean ShowError{set;get;}
    public Integer Bid_Amount{set;get;}
    public List<JE_Auction__c> objList{set;get;}
    public String successMsg{set;get;}
    public String AuctionId{set;get;}
    public Map<String,Decimal> previousBidAmountMap{set;get;}
    public Boolean showTokenField{get;set;}
    public String tokenGenerated{get;set;}
    public String enterToken{get;set;}

    public JEAuctionController(){
        ShowError=false;
        previousBidAmountMap=new Map<String,Decimal>();
        objList=new List<JE_Auction__c>();
        objList=[SELECT Id, Art_or_Craft__c, Creator_Name__c, Image_URL__c, Bid_Amount__c, Bidder_Name__c, Bidder_Email__c
                 FROM JE_Auction__c];
        for(JE_Auction__c obj: objList){
            previousBidAmountMap.put(obj.id,obj.Bid_Amount__c);
        }
        system.debug(objList);
        showTokenField = false;
        
    }
    public void saveBidderInfo(){
        Boolean flag=false;
        //System.assert(true,showTokenField);
        System.debug('showTokenField'+showTokenField);
        System.debug('AuctionIdd '+AuctionId);
        System.debug('objListt '+objList);
        for(JE_Auction__c obj: objList){
            if (obj.Id == AuctionId) {
                Bidder_Email = obj.Bidder_Email__c;
                System.debug('entered here');

                if (previousBidAmountMap.get(obj.Id) >= obj.Bid_Amount__c){
                    ShowError=true;
                    flag=false;
                    successMsg='Bid Amount must be greater than previous bid amount';
                } else if (String.isBlank(obj.Bidder_Name__c)) {
                    ShowError=true;
                    flag=false;
                    successMsg='Please input your Full Name';
                } else if (String.isBlank(obj.Bidder_Email__c)) {
                    ShowError=true;
                    flag=false;
                    successMsg='Please input your Email Address';
                } else if (!obj.Bidder_Email__c.contains('@appirio.com')) {
                    ShowError=true;
                    flag=false;
                    successMsg='Please use your Appirio Email Address';
                } else if (Math.mod((Integer)obj.Bid_Amount__c,100) != 0) {
                    ShowError=true;
                    flag=false;
                    successMsg='The bid amount should be in a multiple of 100';
                }  else if (obj.Bid_Amount__c > 5000) {
                    ShowError=true;
                    flag=false;
                    successMsg='The max bid amount is 5000';
                } else {
                    ShowError=true;
                    flag=true;
                    successMsg='Check your email and Verify Token!!';
                }
            }    
        }
   
       
        if(flag)
        {
        showTokenField = true;  
        System.debug('showTokenField'+showTokenField);
        tokenGenerated = String.valueOf(Integer.valueOf(Math.random()*10000));
        System.debug(tokenGenerated);
        //List<String> toAddresses = new List<String>();
        //toAddresses.add(Bidder_Email);
        //System.debug(Bidder_Email);
        Id conId= [SELECT id,email FROM Contact WHERE email = :Bidder_Email].get(0).id;
        System.debug(conId+'ConId');
        /*
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTargetObjectId('00528000000iIrl');
        mail.setSaveAsActivity(false);   
        mail.setPlainTextBody('Your Token: ' +tokenGenerated +' is generated.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });*/
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTargetObjectId(conId);
        mail.setPlainTextBody('Your Token: ' +tokenGenerated +' is generated.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        System.debug('here');
        System.debug(mail);
        }
       
      
    }
    
    public void VerifyToken(){
        if(enterToken == tokenGenerated){
        showTokenField = false;
        successMsg = 'Thanks! Your bid has been saved';
        update objList;
        }
        else
        {
        successMsg = 'Invalid Verification token.';
        }
        System.debug('here');
        
    }
}