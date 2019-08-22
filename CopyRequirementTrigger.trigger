/*
This trigger calls the trigger dispatcher and passes it an instance of the TriggerHandlerCopyRequirement
Note that the trigger implements all events, and just contains a single line of code to call the TriggerDispatcher.
It is based on the framework discussed in Dan Appleman's 'Advanced Apex Programming'.
Further detail can be found here: http://chrisaldridge.com/triggers/lightweight-apex-trigger-framework/
*/

trigger CopyRequirementTrigger on Copy_Requirements__c (before update, after insert, after update){
    
    SE_Trigger_Settings__c currentTriggerSetting = [SELECT Id, Copy_Requirement_Trigger__c 
                                                    FROM SE_Trigger_Settings__c
                                                    WHERE Name='SE - Trigger Settings'];   
    
    Map<Id,Copy_Requirements__c> oldMapOfCRs = Trigger.OldMap;
    List<Copy_Requirements__c> newCRs = Trigger.New;
    
    if(!currentTriggerSetting.Copy_Requirement_Trigger__c){
        
        
        Map<Id,Copy_Requirements__c> statusIsNowReadyToGo = new Map<Id,Copy_Requirements__c>();
        
        Set<String> APAC_Territories = new Set<String>{'HK','ID','MY','SG'};
        Set<String> BNL_Territories = new Set<String>{'BE','NL'};
        Map<Id,Copy_Requirements__c> APAC_DetailsChange = new Map<Id,Copy_Requirements__c>();
        Map<Id,Copy_Requirements__c> BNL_DetailsChange = new Map<Id,Copy_Requirements__c>();
        
        Map<Id,Copy_Requirements__c> copyNotes = new Map<Id,Copy_Requirements__c>();
        
        Map<Id,Copy_Requirements__c> flagValidate = new Map<Id, Copy_Requirements__c>();
        Map<Id,Copy_Requirements__c> flagTurnOn = new Map<Id, Copy_Requirements__c>();
        Map<Id,Copy_Requirements__c> flagTurnOff = new Map<Id, Copy_Requirements__c>();
        
        if(Trigger.isInsert && newCRs.size() != 0){
            for(Copy_Requirements__c currentNewCR : newCRs){
                if(currentNewCR.Status__c == 'Ready to Go'){
                    statusIsNowReadyToGo.put(currentNewCR.Id,currentNewCR);
                }
                
                /*
if(currentNewCR.CMS_Edit_Flag__c){
flagTurnOn.put(currentNewCR.ID,currentNewCR);
}
*/
            }
        }
        
        if(Trigger.isUpdate && newCRs.size() != 0){
            
            if (Trigger.isBefore){
                for(Copy_Requirements__c currentNewCR : newCRs){
                    if(currentNewCR.CMS_Edit_Flag__c != oldMapOfCRs.get(currentNewCR.Id).CMS_Edit_Flag__c){
                        flagValidate.put(currentNewCR.Id,currentNewCR);
                        System.debug(LoggingLevel.INFO,'// yes we are here');
                    }
                }
            }
            
            /*
if(currentNewCR.CMS_Edit_Flag__c && !oldMapOfCRs.get(currentNewCR.Id).CMS_Edit_Flag__c){
flagTurnOn.put(currentNewCR.ID,currentNewCR);
}

if(!currentNewCR.CMS_Edit_Flag__c && oldMapOfCRs.get(currentNewCR.Id).CMS_Edit_Flag__c){
flagTurnOff.put(currentNewCR.ID,currentNewCR);
}
*/
            
            
            
            
            if(Trigger.isAfter){
                for(Copy_Requirements__c currentNewCR : newCRs){
                    if(oldMapOfCRs.get(currentNewCR.Id).Status__c != currentNewCR.Status__c && currentNewCR.Status__c == 'Ready to Go'){
                        statusIsNowReadyToGo.put(currentNewCR.Id,currentNewCR);
                    }
                    
                    if((currentNewCR.Status__c != null && oldMapOfCRs.get(currentNewCR.Id).Status__c != currentNewCR.Status__c) ||
                       (currentNewCR.Editor_Lookup__c != null && oldMapOfCRs.get(currentNewCR.Id).Editor_Lookup__c != currentNewCR.Editor_Lookup__c) ||
                       (currentNewCR.Writer__c != null && oldMapOfCRs.get(currentNewCR.Id).Writer__c != currentNewCR.Writer__c) ||
                       (currentNewCR.Writer_Deadline__c != null && oldMapOfCRs.get(currentNewCR.Id).Writer_Deadline__c != currentNewCR.Writer_Deadline__c)){
                           if(APAC_Territories.contains(currentNewCR.Territory__c)){
                               APAC_DetailsChange.put(currentNewCR.Id,currentNewCR);
                           }
                           
                           if(BNL_Territories.contains(currentNewCR.Territory__c)){
                               BNL_DetailsChange.put(currentNewCR.Id,currentNewCR);
                           }
                       }
                    
                    if(currentNewCR.Editorial_Notes__c != oldMapOfCRs.get(currentNewCR.Id).Editorial_Notes__c){
                        copyNotes.put(currentNewCR.ID, currentNewCR);
                    }
                    
                }
            }
        }
        
        /*
if(flagTurnOn.size() != 0){
TriggerHandlerCopyRequirement.turnFlagOn(flagTurnOn);
}

if(flagTurnOff.size() != 0){
TriggerHandlerCopyRequirement.turnFlagOff(flagTurnOff);
}
*/
        
        
        if(flagValidate.size() != 0){
            TriggerHandlerCopyRequirement.isItBeingEdittedInCMS(flagValidate,Trigger.OldMap);
            System.debug(LoggingLevel.INFO,'// more than one');
        }
        
        if(statusIsNowReadyToGo.size() != 0){
            TriggerHandlerCopyRequirement.ifTheStatusIsReadyToGo(statusIsNowReadyToGo);
        }
        
        if(APAC_DetailsChange.size() != 0){
            TriggerHandlerCopyRequirement.APACAndBNLDetailsChange(APAC_DetailsChange, APAC_Territories); 
        }
        
        if(BNL_DetailsChange.size() != 0){
            TriggerHandlerCopyRequirement.APACAndBNLDetailsChange(BNL_DetailsChange, BNL_Territories); 
        }
        
        if(copyNotes.size() != 0){
            TriggerHandlerCopyRequirement.copyNoteChangesAcrossOtherCRs(copyNotes);
        }
    }
    
    
    
}