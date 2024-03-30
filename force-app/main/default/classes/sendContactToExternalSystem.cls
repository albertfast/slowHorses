public with sharing class sendContactToExternalSystem {
    public void sendcontact(string firstName,string lastName,string title,string email, id id2){
        sendDataToSalesforceChildSystem(id2);
    }

    @future(callout=true)
    public static void sendDataToSalesforceChildSystem(id id2){
        contact con = [select firstName, lastName, email, title from contact where id=:id2];
        partnerSoapSforceCom.Soap myPartnerSoap= new partnerSoapSforceCom.Soap();
        partnerSoapSforceCom.LoginResult partnerLoginResult= myPartnerSoap.login('fasthorses42@icloud.com', '198591AhJbyOsDR2xioi98n8vU0ww151t');
        //session id
        //we need set this session id on the header
        //call our webservice method of the child class
        System.debug('Generated Session id '+partnerLoginResult.sessionId);
        string sessionIdFetch=partnerLoginResult.sessionId;
        soapSforceComSchemasClassReceivepar.SessionHeader_element webserviceSessionHeader= new soapSforceComSchemasClassReceivepar.SessionHeader_element();
        webserviceSessionHeader.sessionId=sessionIdFetch;
        soapSforceComSchemasClassReceivepar.receiveParametersOrg2 objA=new soapSforceComSchemasClassReceivepar.receiveParametersOrg2();
        objA.SessionHeader=webserviceSessionHeader;
        string status=objA.createContactRecord(con.firstName, con.lastName, con.title, con.email);
        system.debug('status '+status);


    }
    
}