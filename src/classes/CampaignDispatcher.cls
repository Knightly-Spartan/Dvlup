public with sharing class CampaignDispatcher {
  /*
  Created By: Amit SanWariya
  Created On: 10/05/2016
  Purpose: To update child Campaign status when Parent campaign status is changed 
  --------------------------------------------------------------------------
  Modified By:    
  Modified On:  
  Modification: 
  */
  
  public static MAP<string, string> errorMAP = new MAP<string, string>();
  
  private static void Action(
    LIST<Account> triggerOldLIST, 
    MAP<ID, Account> triggerOldMAP,
    LIST<Account> triggerNewLIST,
    MAP<ID, Account> triggerNewMAP, 
    boolean bIsBefore, boolean bIsAfter, boolean bIsInsert, boolean bIsUpdate, boolean bIsDelete){

    // ACTION LOGIC
    // Handle child Campaign Update
  }
}