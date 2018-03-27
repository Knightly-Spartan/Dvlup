// (c) 2012 Appirio, Inc.
//
// TestCustomLookupCtrl
// Lookup for additional email,cc and bcc. 
//
// Original Appirio Asset
// 17 October 2016      Amit Sanwariya    			 	Modified - For Send Email T-548021
//
@isTest
public with sharing class TestCustomLookupCtrl {    
   private static testMethod void CustomLookupCtrlTestMethgod(){
       Contact con = new Contact();
       con.LastName = 'TestContact';
       con.Phone = '9876543210';
       insert con;
       CustomLookupCtrl ctrl=new CustomLookupCtrl();
       ctrl.selectedId = con.Id;
       ctrl.fieldName = 'Name';
       ctrl.objName = 'Contact';
       ctrl.fieldSetAPIName='FieldsForModalLookup';
       ctrl.getSelectedRecord();
       ctrl.OpenLookupPopupCntrl();
   }
}