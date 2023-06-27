/**
 * The DMLOperationsTest class is specifically designed to test the functionality of the methods present in the DMLOperations class.
 * This test class contains several test methods, each one designed to validate individual methods in the DMLOperations class, ensuring their correct behavior.
 * The Salesforce Assert class is employed extensively in these test methods to assert and validate the expected outcomes.
 *
 * Each test method is created to test a corresponding method in the DMLOperations class which includes operations such as insert, update, upsert, and delete on Salesforce standard objects like Account, Contact, and Opportunity.
 */

@IsTest
public with sharing class DMLOperationsTest {

    @IsTest
    static void testInsertNewAccount() {
        // Call the method to test
        Id newAccountId = DMLOperations.insertNewAccount();

        // Assert that an ID was returned
        System.assertNotEquals(null, newAccountId, 'The new account ID should not be null');

        // Retrieve the inserted account from the database
        Account retrievedAccount = [SELECT Id, Name FROM Account WHERE Id = :newAccountId];

        // Assert that the Account was successfully inserted
        System.assertNotEquals(null, retrievedAccount, 'The retrieved account should not be null');
        System.assertEquals(newAccountId, retrievedAccount.Id, 'The IDs should match');
    }

    @IsTest
    static void testCreateAccount() {
        // Test the method
        DMLOperations.createAccount('Test Account', 'Technology');

        // Query to verify the account was created
        Account testAccount = [SELECT Id, Name, Industry FROM Account WHERE Name = 'Test Account'];

        // Assert that the account was successfully created with the correct fields
        Assert.isNotNull(testAccount, 'Account was not created.');
        Assert.areEqual('Test Account', testAccount.Name, 'Account name is incorrect.');
        Assert.areEqual('Technology', testAccount.Industry, 'Account industry is incorrect.');
    }


    @IsTest
    static void testInsertNewContact() {
        // Create a test Account first
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // Call the method to test
        Id newContactId = DMLOperations.insertNewContact(testAccount.Id);

        // Assert that an ID was returned
        System.assertNotEquals(null, newContactId, 'The new contact ID should not be null');

        // Retrieve the inserted contact from the database
        Contact retrievedContact = [SELECT Id, LastName, AccountId FROM Contact WHERE Id = :newContactId];

        // Assert that the Contact was successfully inserted and linked to the correct Account
        System.assertNotEquals(null, retrievedContact, 'The retrieved contact should not be null');
        System.assertEquals(newContactId, retrievedContact.Id, 'The IDs should match');
        System.assertEquals(testAccount.Id, retrievedContact.AccountId, 'The Account IDs should match');
    }
    
    @IsTest
    static void testUpdateContactLastName() {
        // Create a test Contact first
        Contact testContact = new Contact(LastName = 'Doe');
        insert testContact;

        // Call the method to test
        String newLastName = 'Smith';
        DMLOperations.updateContactLastName(testContact.Id, newLastName);

        // Retrieve the updated Contact from the database
        Contact updatedContact = [SELECT Id, LastName FROM Contact WHERE Id = :testContact.Id];

        // Assert that the Contact's last name was successfully updated
        System.assertEquals(newLastName, updatedContact.LastName, 'The last name should be updated');
    }

    @IsTest
    static void testUpdateOpportunityStage() {
        // Create a test Account first
        Account testAcc = new Account(Name = 'Test Account');
        insert testAcc;
        
        // Create a test Opportunity
        Opportunity testOpp = new Opportunity(Name = 'Test Opportunity', AccountId = testAcc.Id, StageName = 'Prospecting', CloseDate = Date.today().addMonths(3));
        insert testOpp;

        // Call the method to test
        String newStage = 'Closed Won';
        DMLOperations.updateOpportunityStage(testOpp.Id, newStage);

        // Retrieve the updated Opportunity from the database
        Opportunity updatedOpp = [SELECT Id, StageName FROM Opportunity WHERE Id = :testOpp.Id];

        // Assert that the Opportunity's stage was successfully updated
        System.assertEquals(newStage, updatedOpp.StageName, 'The stage should be updated');
    }

    @IsTest
    static void testUpdateAccountFields() {
        // Create an account for the test
        Account acc = new Account(Name = 'Test Account', Industry = 'Technology');
        insert acc;

        // Test the method
        DMLOperations.updateAccountFields(acc.Id, 'Updated Account', 'Finance');

        // Query the updated account
        Account updatedAccount = [SELECT Id, Name, Industry FROM Account WHERE Id = :acc.Id];

        // Assert that the account fields were successfully updated
        Assert.areEqual('Updated Account', updatedAccount.Name, 'Account name was not updated correctly.');
        Assert.areEqual('Finance', updatedAccount.Industry, 'Account industry was not updated correctly.');
    }


    @IsTest
    static void testUpsertOpportunityForAccount() {
        // Create a test Account first
        Account testAcc = new Account(Name = 'Test Account');
        insert testAcc;
    
        // Call the method to test with the Account Id
        DMLOperations.upsertOpportunityForAccount(testAcc.Id);
    
        // Retrieve the Opportunity from the database
        Opportunity retrievedOpp = [SELECT Id, Name, StageName FROM Opportunity WHERE AccountId = :testAcc.Id];
    
        // Assert that the Opportunity was successfully upserted
        System.assertEquals(String.valueOf(testAcc.Id), retrievedOpp.Name, 'The name of the Opportunity should match the Account Id');
        System.assertEquals('Prospecting', retrievedOpp.StageName, 'The stage of the Opportunity should be set correctly');
    
        // Call the method to test again to check the upsert operation
        DMLOperations.upsertOpportunityForAccount(testAcc.Id);
    
        // Retrieve the updated Opportunity from the database
        Opportunity updatedOpp = [SELECT Id, Name, StageName FROM Opportunity WHERE AccountId = :testAcc.Id];
    
        // Assert that the Opportunity was successfully updated
        System.assertEquals(String.valueOf(testAcc.Id), updatedOpp.Name, 'The name of the updated Opportunity should match the Account Id');
    }
    
    @IsTest
    static void testUpsertOpportunities() {
        // Prepare the Account name
        String accountName = 'Test Account';
    
        // Prepare the Opportunity names
        List<String> oppNames = new List<String>{ 'Opp 1', 'Opp 2', 'Opp 3' };
    
        // Call the method to test
        DMLOperations.upsertOpportunities(accountName, oppNames);
    
        // Retrieve the Account from the database
        Account retrievedAcc = [SELECT Id, Name FROM Account WHERE Name = :accountName];
        
        // Retrieve the Opportunities from the database
        List<Opportunity> retrievedOpps = [SELECT Id, Name FROM Opportunity WHERE AccountId = :retrievedAcc.Id];
        
        // Assert that the Account was successfully upserted
        System.assertEquals(accountName, retrievedAcc.Name, 'The upserted Account should have the provided name');
    
        // Assert that the Opportunities were successfully upserted
        System.assertEquals(oppNames.size(), retrievedOpps.size(), 'The number of upserted Opportunities should match the number of Opportunity names provided');
    
        for (Opportunity opp : retrievedOpps) {
            System.assert(oppNames.contains(opp.Name), 'All Opportunity names should be found in the database');
        }
    
        // Call the method to test again to check the upsert operation
        DMLOperations.upsertOpportunities(accountName, oppNames);
    
        // Retrieve the updated Opportunities from the database
        List<Opportunity> updatedOpps = [SELECT Id, Name FROM Opportunity WHERE AccountId = :retrievedAcc.Id];
        
        // Assert that the Opportunities were successfully updated
        System.assertEquals(oppNames.size(), updatedOpps.size(), 'The number of updated Opportunities should match the number of Opportunity names provided');
    
        for (Opportunity opp : updatedOpps) {
            System.assert(oppNames.contains(opp.Name), 'All updated Opportunity names should be found in the database');
        }
    }

    @IsTest
    static void testUpsertAccountsWithContacts() {
        // Prepare the Accounts
        Account acc = new Account(Name = 'Test Account 5');
        insert acc;

        // Prepare the Contacts and Account names
        List<Contact> contactsToUpsert = new List<Contact> {
            new Contact(LastName = 'Test Contact 1', AccountId = acc.Id),
            new Contact(LastName = 'Test Contact 2'),
            new Contact(LastName = 'Test Contact 3'),
            new Contact(LastName = 'Test Contact 4')
        };

        List<String> accountNames = new List<String>{ 'Test Account 1', 'Test Account 4', 'Test Account 2', 'Test Account 3' };

        // Call the method to test
        DMLOperations.upsertAccountsWithContacts(contactsToUpsert, accountNames);
        accountNames.add(acc.Name);

        // Query the Contacts and Accounts from the database
        List<Contact> retrievedContacts = [SELECT Id, LastName, Account.Name FROM Contact WHERE LastName IN ('Test Contact 1', 'Test Contact 2', 'Test Contact 3', 'Test Contact 4')];
        List<Account> retrievedAccounts = [SELECT Id, Name FROM Account WHERE Name IN :accountNames];

        // Assert that the Accounts and Contacts have been upserted
        System.assertEquals(accountNames.size(), retrievedAccounts.size(), 'All Accounts should have been upserted');
        System.assertEquals(contactsToUpsert.size(), retrievedContacts.size(), 'All Contacts should have been upserted');

        // Assert that each Contact is linked to its Account
        for (Contact contact : retrievedContacts) {
            System.assertEquals(contact.Account.Name, contact.LastName.replace('Test Contact ', 'Test Account '), 'Contact should be linked to its Account');
        }
    }
    
    @IsTest
    static void testInsertAndDeleteLeads() {
        // Prepare the Lead names
        List<String> leadNames = new List<String>{ 'Test Lead 1', 'Test Lead 2', 'Test Lead 3' };
    
        // Call the method to test
        DMLOperations.insertAndDeleteLeads(leadNames);
    
        // Query the Leads from the database
        List<Lead> retrievedLeads = [SELECT Id, LastName FROM Lead WHERE LastName IN :leadNames];
    
        // Assert that the Leads have been deleted
        System.assertEquals(0, retrievedLeads.size(), 'All Leads should have been deleted');
    }



    @IsTest
    static void testCreateAndDeleteCases() {
        // Create a test account
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // Test the method
        DMLOperations.createAndDeleteCases(testAccount.Id, 5);

        // Query to verify cases were deleted
        List<Case> cases = [SELECT Id FROM Case WHERE AccountId = :testAccount.Id];

        // Assert that no cases exist for the account
        Assert.areEqual(0, cases.size(), 'Cases were not successfully deleted.');
    }

}