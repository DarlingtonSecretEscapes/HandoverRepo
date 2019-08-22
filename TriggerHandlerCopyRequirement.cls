/*
Copy Requirement Trigger - 
11/10/17 - Class Reformatting by Darlington
*/

public class TriggerHandlerCopyRequirement{

    
    public class CopyRequirementsAndOpportunities{
        public Copy_Requirements__c currentCRBeingUpdated;
        public Opportunity relatedOpportunity;
        public List<Copy_Requirements__c> relatedCopyRequirementsToOpp; 
        
        public CopyRequirementsAndOpportunities(Copy_Requirements__c nCurrentOppBeingUpdated){
            currentCRBeingUpdated = nCurrentOppBeingUpdated;
            relatedCopyRequirementsToOpp = new List<Copy_Requirements__c>();
        }
    }
    
    public static List<CopyRequirementsAndOpportunities> getOppsRelatedToCopyManager(Map<Id,Copy_Requirements__c> mapOfCopyRequirements){
        List<CopyRequirementsAndOpportunities> resultListOfCopyRequirementsAndOpportunities =
        new List<CopyRequirementsAndOpportunities>();
        
        System.debug('Map Size: ' + mapOfCopyRequirements.size());
        
        List<Id> listOfRelatedOpportunitiesIds = new List<Id>();
        for(Copy_Requirements__c CRRecord: mapOfCopyRequirements.values()){
            resultListOfCopyRequirementsAndOpportunities.add(new CopyRequirementsAndOpportunities(CRRecord));
            listOfRelatedOpportunitiesIds.add(CRRecord.Opportunity__c); 
        }
        
        List<Opportunity> relatedOpportuninties = [SELECT Id, CMS_Edit_Flag__c, CMS_Edit_User__c, AT_Status__c, BE_Status__c, CH_Status__c, CZ_Status__c, DE_Status__c, DK_Status__c, ES_Status__c, FR_Status__c, HK_Status__c, HU_Status__c, ID_Status__c, IT_Status__c, MY_Status__c, NL_Status__c, NO_Status__c, PL_Status__c, SE_Status__c, SG_Status__c, SK_Status__c, UK_Status__c, US_Status__c
                           FROM Opportunity WHERE Id IN : listOfRelatedOpportunitiesIds];
                       
        List<CopyRequirementsAndOpportunities> noRelatedOppsCRs = matchOppsAndCRs(mapOfCopyRequirements.values(),
                        relatedOpportuninties,resultListOfCopyRequirementsAndOpportunities);
        System.debug('// noRelatedOppsCRs size: ' + noRelatedOppsCRs.size());
        resultListOfCopyRequirementsAndOpportunities = getOppsRealatedCRs(listOfRelatedOpportunitiesIds,noRelatedOppsCRs);
      
        
        return resultListOfCopyRequirementsAndOpportunities;
    }
    
    public static List<CopyRequirementsAndOpportunities> getOppsRealatedCRs(List<Id> relatedOppIds,
                                         List<CopyRequirementsAndOpportunities> ListOfCopyRequirementsAndOpportunities)
    {
        List<CopyRequirementsAndOpportunities> resultListOfCopyRequirementsAndOpportunities =
        new List<CopyRequirementsAndOpportunities>();
        
        List<Copy_Requirements__c> relatedCRsToOpps = [SELECT Id, Opportunity__c, Territory__c
                                                      FROM Copy_Requirements__c
                                                      WHERE Opportunity__c IN : relatedOppIds];
        for(CopyRequirementsAndOpportunities CR : ListOfCopyRequirementsAndOpportunities ){
            for(Copy_Requirements__c relatedCR : relatedCRsToOpps){
                if(CR.relatedOpportunity.Id == relatedCR.Opportunity__c){
                    CR.relatedCopyRequirementsToOpp.add(relatedCR);
                }
            }
            resultListOfCopyRequirementsAndOpportunities.add(CR);
        }
        return resultListOfCopyRequirementsAndOpportunities;
    }
    
    public static List<CopyRequirementsAndOpportunities> matchOppsAndCRs(List<Copy_Requirements__c> inputListOfCRs, 
                                       List<Opportunity> RelatedOpportunities,
                                      List<CopyRequirementsAndOpportunities> ListOfCopyRequirementsAndOpportunities)
    {
        List<CopyRequirementsAndOpportunities> resultListOfCopyRequirementsAndOpportunities = new List<CopyRequirementsAndOpportunities>();
        Map<Id, Opportunity> CRIdsAndTheirOpps = new Map<Id, Opportunity>();
        for(Copy_Requirements__c currentCR : inputListOfCRs){
            for(Integer iterator = 0; iterator < RelatedOpportunities.size(); iterator++){

                if(currentCR.Opportunity__c == RelatedOpportunities[iterator].Id){
                    CRIdsAndTheirOpps.put(currentCR.Id, RelatedOpportunities[iterator]);
                    break;
                }
            }
        }
        
        for(CopyRequirementsAndOpportunities currentCRAndOppObj : ListOfCopyRequirementsAndOpportunities){
            for (Id CR_Id : CRIdsAndTheirOpps.keySet()){
                if(currentCRAndOppObj.currentCRBeingUpdated.Id == CR_Id){
                        currentCRAndOppObj.relatedOpportunity = CRIdsAndTheirOpps.get(CR_Id);
                        resultListOfCopyRequirementsAndOpportunities.add(currentCRAndOppObj);
                    }
            }
        }
        
        return resultListOfCopyRequirementsAndOpportunities;
                                         
    }
    
    // updates the territory status on the opp to 'Ready to Approve' if the copy requirement for that
    // territory is set to ready to go on the 'Copy Requirement'
    public static void ifTheStatusIsReadyToGo(Map<Id, Copy_Requirements__c> inputRecords){
        
        List<CopyRequirementsAndOpportunities> ListOfCopyRequirementsAndOpportunities = getOppsRelatedToCopyManager(inputRecords);
        List<Opportunity> listOfOppsToUpdate = new List<Opportunity>();
        Set<Id> alreadyUpdatedOpps = new Set<Id>(); 
        

        
        for(CopyRequirementsAndOpportunities currentObjRecord : ListOfCopyRequirementsAndOpportunities){
            currentObjRecord.relatedOpportunity.put(currentObjRecord.currentCRBeingUpdated.Territory__c+'_Status__c','Ready to Approve');
            
            if(!alreadyUpdatedOpps.contains(currentObjRecord.relatedOpportunity.Id)){
                listOfOppsToUpdate.add(currentObjRecord.relatedOpportunity);
                alreadyUpdatedOpps.add(currentObjRecord.relatedOpportunity.Id);
            }
        }
        
        update listOfOppsToUpdate;
    }
    
    public static List<Copy_Requirements__c> removeDuplicates(Set<Copy_Requirements__c> inputCRs){
        List<Copy_Requirements__c> listOfCRs = new List<Copy_Requirements__c>();
        return listOfCRs;
    }
    
    public static void APACAndBNLDetailsChange(Map<Id, Copy_Requirements__c> inputRecords, Set<String> APAC_BNLTerritories){
        List<CopyRequirementsAndOpportunities> ListOfCopyRequirementsAndOpportunities = getOppsRelatedToCopyManager(inputRecords);
        Set<Copy_Requirements__c> CRsToUpdate = new Set<Copy_Requirements__c>();
        
        for(CopyRequirementsAndOpportunities currentCR : ListOfCopyRequirementsAndOpportunities){
            for(Copy_Requirements__c currentRealatedCR : currentCR.relatedCopyRequirementsToOpp){
                
                System.debug('APAC_BNLTerritories: ' + APAC_BNLTerritories);
                System.debug('currentCR.currentCRBeingUpdated.Territory__c: ' + currentCR.currentCRBeingUpdated.Territory__c);
                
                if(currentCR.currentCRBeingUpdated.Id != currentRealatedCR.Id && APAC_BNLTerritories.contains(currentRealatedCR.Territory__c)){
                    currentRealatedCR.Status__c = currentCR.currentCRBeingUpdated.Status__c;
                    currentRealatedCR.Editor_Lookup__c = currentCR.currentCRBeingUpdated.Editor_Lookup__c;
                    currentRealatedCR.Writer__c = currentCR.currentCRBeingUpdated.Writer__c;
                    currentRealatedCR.Writer_Deadline__c = currentCR.currentCRBeingUpdated.Writer_Deadline__c;
                    if(!CRsToUpdate.contains(currentRealatedCR)){
                        CRsToUpdate.add(currentRealatedCR);
                    }
                }
                
            }
        }
        
        List<Copy_Requirements__c> finalUpdates = new List<Copy_Requirements__c>();
        finalUpdates.addAll(CRsToUpdate);
      //  System.debug(LoggingLevel.INFO,'// CRsToUpdate: ' + CRsToUpdate);
        update finalUpdates;
        
    }
    
    public static void copyNoteChangesAcrossOtherCRs(Map<Id, Copy_Requirements__c> inputRecords){
        List<CopyRequirementsAndOpportunities> ListOfCopyRequirementsAndOpportunities = getOppsRelatedToCopyManager(inputRecords);
        List<Copy_Requirements__c> CRsToUpdate = new List<Copy_Requirements__c>();
        
        for(CopyRequirementsAndOpportunities currentCR : ListOfCopyRequirementsAndOpportunities){
            for(Copy_Requirements__c currentRealatedCR : currentCR.relatedCopyRequirementsToOpp){
                currentRealatedCR.Editorial_Notes__c = currentCR.currentCRBeingUpdated.Editorial_Notes__c;
                CRsToUpdate.add(currentRealatedCR);
            }
        }
        
        update CRsToUpdate;
    }
    
    
    public static void isItBeingEdittedInCMS(Map<Id, Copy_Requirements__c> inputRecords, Map<Id,Copy_Requirements__c> oldValues){
        System.debug(LoggingLevel.INFO,'// In method');
        List<Opportunity> OppsToUpdate = new List<Opportunity>();
        List<CopyRequirementsAndOpportunities> ListOfCopyRequirementsAndOpportunities = getOppsRelatedToCopyManager(inputRecords);
        
        User currentUser = new User();
        
        try{
            currentUser = [SELECT Id, Name, GDG_Territory__c, ProfileId
                           FROM User 
                           WHERE Id = : UserInfo.getUserId()];
            System.debug(LoggingLevel.INFO,'// None Found');
        }catch(Exception e){
            currentUser = null;
            System.debug(LoggingLevel.INFO,'// Current user null');
           
        }
        
        //AND (ProfileId =: '00ew0000001pG9p' OR ProfileId =:'00ew00000015uTb')

        System.debug(LoggingLevel.INFO,'// UserInfo.getProfileId(): ' + UserInfo.getProfileId() + ' / Needed : 00ew00000015uTb ');
        
        if(currentUser.ProfileId == '00ew0000001pG9p' || currentUser.ProfileId =='00ew00000015uTb'){
            System.debug(LoggingLevel.INFO,'// We are past the first If statement');
            for(CopyRequirementsAndOpportunities currentCR : ListOfCopyRequirementsAndOpportunities){  
                System.debug(LoggingLevel.INFO,'// We are past the for loop');
                
                if(currentUser.GDG_Territory__c == currentCR.currentCRBeingUpdated.Territory__c){
                    if(currentCR.relatedOpportunity.CMS_Edit_Flag__c == TRUE ){
                        if(!currentCR.currentCRBeingUpdated.CMS_Edit_Flag__c && oldValues.get(currentCR.currentCRBeingUpdated.Id).CMS_Edit_Flag__c){
                            currentCR.relatedOpportunity.CMS_Edit_Flag__c = FALSE;
                            currentCR.currentCRBeingUpdated.CMS_Edit_Flag__c = FALSE; 
                            OppsToUpdate.add(currentCR.relatedOpportunity);
                            System.debug(LoggingLevel.INFO,'// The Flag is FALSE');
                        }else if (!oldValues.get(currentCR.currentCRBeingUpdated.Id).CMS_Edit_Flag__c){
                            currentCR.currentCRBeingUpdated.addError(currentCR.relatedOpportunity.CMS_Edit_User__c +' is already editing this deal.');
                        }
                    }else{
                        System.debug(LoggingLevel.INFO,'// the flag is false');
                        if(currentCR.currentCRBeingUpdated.CMS_Edit_Flag__c && !oldValues.get(currentCR.currentCRBeingUpdated.Id).CMS_Edit_Flag__c){
                            System.debug(LoggingLevel.INFO,'// from true to false');
                            currentCR.relatedOpportunity.CMS_Edit_Flag__c = TRUE;
                            currentCR.currentCRBeingUpdated.CMS_Edit_Flag__c = TRUE; 
                            OppsToUpdate.add(currentCR.relatedOpportunity);
                        }
                    }
                }else{
                    System.debug(LoggingLevel.INFO,'// wrong territory');
                    currentCR.currentCRBeingUpdated.addError('You are in the wrong terrirory');
                }

            }
        }
        
        if(OppsToUpdate.size() != 0){
            update OppsToUpdate;
        }
        
    }

}