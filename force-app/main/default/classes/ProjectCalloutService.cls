public class ProjectCalloutService {
    //Complete the implementation for business and callout logic
    @InvocableMethod
    public static void postOpportunityToPMS(List<Id> opportunityIds){
        QueueablePMSCall queueable = new QueueablePMSCall(opportunityIds);
        System.enqueueJob(queueable);
    }
    
    public class QueueablePMSCall implements Queueable, Database.AllowsCallouts {
        private List<Id> opportunityIds;
        
        public QueueablePMSCall(List<Id> opportunityIds) {
            this.opportunityIds = opportunityIds;
        }
        
        public void execute(QueueableContext context) {
            Opportunity opp = [SELECT Id, Name,Account.Name, CloseDate, Amount, StageName FROM Opportunity WHERE Id = :opportunityIds[0]];
            
            String serviceToken = ServiceTokens__c.getValues('ProjectServiceToken').Token__c;
            String payload = '{';
            payload += '"opportunityId": "' + opp.Id + '",';
            payload += '"opportunityName": "' + opp.Name + '",';
            payload += '"accountName": "' + opp.Account.Name + '",';
            payload += ' "closeDate" : "'+String.ValueOf(opp.CloseDate).mid(0,10) + '",';
            payload += '"amount": ' + opp.Amount + '';
            payload += '}';
            
            HttpRequest request = new HttpRequest();
                request.setTimeout(60000);
                request.setEndpoint('callout:ProjectService');
                request.setEndpoint('https://external-pms-system.com/api/opportunities');
                request.setMethod('POST');
                request.setHeader('Content-Type', 'application/json');
                request.setHeader('token', serviceToken);
                request.setBody(payload);
            
            Http http = new Http();
            HttpResponse response = http.send(request);
            
            if (response.getStatusCode() == 200) {
                // Set the opportunity stage to "Submitted Project" if the call was successful
                opp.StageName = 'Submitted Project';
                update opp;
            } else {
                // Set the opportunity stage to "Resubmit Project" if the call was unsuccessful
                opp.StageName = 'Resubmit Project';
                update opp;
                
                // Retry the callout logic by enqueuing another job for the same opportunity
                System.enqueueJob(this);
            }
        }
    }
}