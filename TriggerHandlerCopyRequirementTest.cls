@isTest(seeAllData=true)
public class TriggerHandlerCopyRequirementTest {

    static testMethod void testWithNewCopyReq1() {

        utility_Class.runOnce = true;
        List<Account> acc = new List<Account>{};
        for(Integer i = 0; i < 1; i++){
            Account a = new Account(
                Name = 'Test ' + i,
                RecordTypeId ='012w0000000iIOK'
            );
            acc.add(a);
        }
        insert acc;

        List<Opportunity> opps = new List<Opportunity>{};
        for(Integer i = 0; i < 12; i++){
            Opportunity o = new Opportunity(
                Name = 'Test ' + i,
                Repeat__c = 'No',
                RecordTypeId = '012w0000000iTxG',
                StageName = 'Sales Admin',
                CMS_Edit_Flag__c = FALSE,
                CloseDate = date.today(),
                AT_Status__c = 'Slot Requested',
                BE_Status__c = 'Slot Requested',
                CH_Status__c = 'Slot Requested',
                DE_Status__c = 'Slot Requested',
                DK_Status__c = 'Slot Requested',
                ES_Status__c = 'Slot Requested',
                FR_Status__c = 'Slot Requested',
                HK_Status__c = 'Slot Requested',
                ID_Status__c = 'Slot Requested',
                IT_Status__c = 'Slot Requested',
                MY_Status__c = 'Slot Requested',
                NL_Status__c = 'Slot Requested',
                NO_Status__c = 'Slot Requested',
                SE_Status__c = 'Slot Requested',
                SG_Status__c = 'Slot Requested',
                UK_Status__c = 'Slot Requested',
                US_Status__c = 'Slot Requested',
                Account = acc[0]
            );
            opps.add(o);
        }
        insert opps;
        utility_Class.runOnce = true;

        List<String> terrList = new List<String> {'AT','BE','CH','DE','DK','ES','FR','HK','ID','IT','MY','NO','NL','SE','SG','UK','US'};
        List<String> langList= new List<String> {'German','Dutch','German','German','Danish','Spanish','French','English','English','Italian','English','Norwegian','Dutch','Swedish','English','English','English'};

        List<Copy_Requirements__c> newCRs = new List<Copy_Requirements__c>{};
        for(Integer i = 0; i < 6; i++){
            Copy_Requirements__c CR = new Copy_Requirements__c(
                Territory__c = terrList[i],
                Opportunity__c = opps[0].Id,
                CMS_Edit_Flag__c = FALSE,
                Status__c = 'Ready to Go'
            );
            newCRs.add(CR);
        }
        insert newCRs;

    }

    static testMethod void testWithNewCopyReq2() {

        utility_Class.runOnce = true;
        List<Account> acc = new List<Account>{};
        for(Integer i = 0; i < 1; i++){
            Account a = new Account(
                Name = 'Test ' + i,
                RecordTypeId ='012w0000000iIOK'
            );
            acc.add(a);
        }
        insert acc;

        List<Opportunity> opps = new List<Opportunity>{};
        for(Integer i = 0; i < 12; i++){
            Opportunity o = new Opportunity(
                Name = 'Test ' + i,
                Repeat__c = 'No',
                RecordTypeId = '012w0000000iTxG',
                StageName = 'Sales Admin',
                CMS_Edit_Flag__c = FALSE,
                CloseDate = date.today(),
                AT_Status__c = 'Slot Requested',
                BE_Status__c = 'Slot Requested',
                CH_Status__c = 'Slot Requested',
                DE_Status__c = 'Slot Requested',
                DK_Status__c = 'Slot Requested',
                ES_Status__c = 'Slot Requested',
                FR_Status__c = 'Slot Requested',
                HK_Status__c = 'Slot Requested',
                ID_Status__c = 'Slot Requested',
                IT_Status__c = 'Slot Requested',
                MY_Status__c = 'Slot Requested',
                NL_Status__c = 'Slot Requested',
                NO_Status__c = 'Slot Requested',
                SE_Status__c = 'Slot Requested',
                SG_Status__c = 'Slot Requested',
                UK_Status__c = 'Slot Requested',
                US_Status__c = 'Slot Requested',
                Account = acc[0]
            );
            opps.add(o);
        }
        insert opps;
        utility_Class.runOnce = true;

        List<String> terrList = new List<String> {'AT','BE','CH','DE','DK','ES','FR','HK','ID','IT','MY','NO','NL','SE','SG','UK','US'};
        List<String> langList= new List<String> {'German','Dutch','German','German','Danish','Spanish','French','English','English','Italian','English','Norwegian','Dutch','Swedish','English','English','English'};

        Freelancers__c writer2 = new Freelancers__c(
          Name = 'Test'
        );
        insert writer2;

        Test.startTest();
        List<Copy_Requirements__c> newCRs = new List<Copy_Requirements__c>{};
        for(Integer i = 6; i < 17; i++){
            Copy_Requirements__c CR = new Copy_Requirements__c(
                Territory__c = terrList[i],
                Opportunity__c = opps[0].Id,
                CMS_Edit_Flag__c = FALSE,
                Editorial_Notes__c = 'Test',
                Status__c = 'Ready to Go',
                Writer__c = writer2.Id
            );
            newCRs.add(CR);
        }
        insert newCRs;

        Freelancers__c writer = new Freelancers__c(
          Name = 'Test'
        );
        insert writer;

        utility_Class.runOnce = true;
        newCRs[7].CMS_Edit_Flag__c = FALSE;
        newCRs[7].Status__c = 'Copy Received';
        newCRs[7].Writer__c = writer.Id;
        update newCRs[7];

        utility_Class.runOnce = true;
        newCRs[7].CMS_Edit_Flag__c = TRUE;
        newCRs[7].Status__c = 'New Copy Loaded';
        update newCRs[7];
        Test.stopTest();
    }

    static testMethod void testWithNewCopyReq3() {
        utility_Class.runOnce = true;
        Account acc = new Account(
        	Name = 'Test ',
          RecordTypeId ='012w0000000iIOK'
        );
        insert acc;

        Opportunity opp = new Opportunity(
        	Name = 'Test ',
          Repeat__c = 'No',
          RecordTypeId = '012w0000000iTxG',
          StageName = 'Sales Admin',
          CMS_Edit_Flag__c = TRUE,
          CloseDate = date.today(),
          AT_Status__c = 'Slot Requested',
          BE_Status__c = 'Slot Requested',
          CH_Status__c = 'Slot Requested',
          DE_Status__c = 'Slot Requested',
          DK_Status__c = 'Slot Requested',
          ES_Status__c = 'Slot Requested',
          FR_Status__c = 'Slot Requested',
          HK_Status__c = 'Slot Requested',
          ID_Status__c = 'Slot Requested',
          IT_Status__c = 'Slot Requested',
          MY_Status__c = 'Slot Requested',
          NL_Status__c = 'Slot Requested',
          NO_Status__c = 'Slot Requested',
          SE_Status__c = 'Slot Requested',
          SG_Status__c = 'Slot Requested',
          UK_Status__c = 'Slot Requested',
          US_Status__c = 'Slot Requested',
          Account = acc
        );
        insert opp;

        Freelancers__c writer = new Freelancers__c(
          Name = 'Test'
        );
        insert writer;

        utility_Class.runOnce = true;
        Copy_Requirements__c req = new Copy_Requirements__c(
        	Territory__c = 'HK',
        	Language__c = 'English',
          Opportunity__c = opp.Id,
          CMS_Edit_Flag__c = FALSE,
          Editorial_Notes__c = 'Test',
          Status__c = 'Ready to Go',
          Writer__c = writer.Id
        );
        insert req;
    }

    static testMethod void testWithUpdCopyReq() {

        utility_Class.runOnce = true;
        Account acc = new Account(
        	Name = 'Test ',
          RecordTypeId ='012w0000000iIOK'
        );
        insert acc;

        Opportunity opp = new Opportunity(
        	Name = 'Test ',
          Repeat__c = 'No',
          RecordTypeId = '012w0000000iTxG',
          StageName = 'Sales Admin',
          CMS_Edit_Flag__c = TRUE,
          CloseDate = date.today(),
          AT_Status__c = 'Slot Requested',
          BE_Status__c = 'Slot Requested',
          CH_Status__c = 'Slot Requested',
          DE_Status__c = 'Slot Requested',
          DK_Status__c = 'Slot Requested',
          ES_Status__c = 'Slot Requested',
          FR_Status__c = 'Slot Requested',
          HK_Status__c = 'Slot Requested',
          ID_Status__c = 'Slot Requested',
          IT_Status__c = 'Slot Requested',
          MY_Status__c = 'Slot Requested',
          NL_Status__c = 'Slot Requested',
          NO_Status__c = 'Slot Requested',
          SE_Status__c = 'Slot Requested',
          SG_Status__c = 'Slot Requested',
          UK_Status__c = 'Slot Requested',
          US_Status__c = 'Slot Requested',
          Account = acc
        );
        insert opp;

        Freelancers__c writer = new Freelancers__c(
          Name = 'Test'
        );
        insert writer;

        Copy_Requirements__c req = new Copy_Requirements__c(
        	Territory__c = 'HK',
        	Language__c = 'English',
          Opportunity__c = opp.Id,
          CMS_Edit_Flag__c = FALSE,
          Editorial_Notes__c = 'Test',
          Status__c = 'Ready to Go'
        );
        insert req;

        Copy_Requirements__c req2 = new Copy_Requirements__c(
        	Territory__c = 'SG',
        	Language__c = 'English',
          Opportunity__c = opp.Id,
          CMS_Edit_Flag__c = FALSE,
          Editorial_Notes__c = 'Test',
          Status__c = 'Ready to Go'
        );
        insert req2;

        req.Status__c = 'Copy Received';
        req.Editorial_Notes__c = 'NEW TEST';
        req.Writer__c = writer.Id;
        update req;

    }

    static testMethod void testWithUpdCopyReq2() {

        utility_Class.runOnce = true;
        Account acc = new Account(
          Name = 'Test ',
          RecordTypeId ='012w0000000iIOK'
        );
        insert acc;

        Opportunity opp = new Opportunity(
          Name = 'Test ',
          Repeat__c = 'No',
          RecordTypeId = '012w0000000iTxG',
          StageName = 'Sales Admin',
          CMS_Edit_Flag__c = TRUE,
          CloseDate = date.today(),
          AT_Status__c = 'Slot Requested',
          BE_Status__c = 'Slot Requested',
          CH_Status__c = 'Slot Requested',
          DE_Status__c = 'Slot Requested',
          DK_Status__c = 'Slot Requested',
          ES_Status__c = 'Slot Requested',
          FR_Status__c = 'Slot Requested',
          HK_Status__c = 'Slot Requested',
          ID_Status__c = 'Slot Requested',
          IT_Status__c = 'Slot Requested',
          MY_Status__c = 'Slot Requested',
          NL_Status__c = 'Slot Requested',
          NO_Status__c = 'Slot Requested',
          SE_Status__c = 'Slot Requested',
          SG_Status__c = 'Slot Requested',
          UK_Status__c = 'Slot Requested',
          US_Status__c = 'Slot Requested',
          Account = acc
        );
        insert opp;

        Copy_Requirements__c req3 = new Copy_Requirements__c(
          Territory__c = 'BE',
          Language__c = 'Dutch',
          Opportunity__c = opp.Id,
          CMS_Edit_Flag__c = FALSE,
          Editorial_Notes__c = 'Test',
          Status__c = 'Ready to Go'
        );
        insert req3;

        Copy_Requirements__c req4 = new Copy_Requirements__c(
          Territory__c = 'NL',
          Language__c = 'Dutch',
          Opportunity__c = opp.Id,
          CMS_Edit_Flag__c = FALSE,
          Editorial_Notes__c = 'Test',
          Status__c = 'Ready to Go'
        );
        insert req4;

        req3.Status__c = 'Copy Received';
        req3.Editorial_Notes__c = 'NEW TEST';
        update req3;

    }

}