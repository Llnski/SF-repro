public with sharing class EmailSend {
    public EmailSend() {
    }
    void submitAndProcessApprovalRequest() {
        List<Contact> cont = [SELECT Name FROM Contact WHERE Birthdate != null AND Birthdate = TODAY];
        User user1 = [SELECT Id FROM User WHERE Alias='testAlias'];
        for(Contact c: cont){
            Approval.ProcessSubmitRequest req1 = 
                new Approval.ProcessSubmitRequest();
            req1.setObjectId(c.Id);
            req1.setSubmitterId(c.Id); 
            req1.setProcessDefinitionNameOrId('Birthday_Approval');
            req1.setSkipEntryCriteria(true);
            List<Id> approvers = new List<Id>{user1.Id};

            req1.setNextApproverIds(approvers);
            EmailTemplate bdayTemp = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body
             from EmailTemplate where name = 'Birthday_Template'];

            req1.setComments('comments'); 

            Approval.ProcessResult result = Approval.process(req1);
            System.assert(result.isSuccess());
            System.assertEquals(
                'Pending', result.getInstanceStatus(), 
                'Instance Status' + result.getInstanceStatus());
        }
    }
}