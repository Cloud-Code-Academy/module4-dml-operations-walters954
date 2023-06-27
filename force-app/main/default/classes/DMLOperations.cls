/**
 * The DMLOperations class serves as a deep dive into Data Manipulation Language (DML) in Apex.
 * It covers fundamental DML operations such as insert, update, upsert, and delete.
 *
 * This class introduces developers to the concept of manipulating Salesforce records in Apex. 
 * It discusses how to use DML operations to create, update, and delete records. 
 * This class uses standard Salesforce objects like Account, Contact, and Opportunity for demonstration.
 * 
 * Topics covered in this class include:
 * - Understanding how to use insert DML operation to create records in Salesforce.
 * - Understanding how to use update and upsert DML operations to update existing records in Salesforce.
 * - Understanding how to use delete DML operation to remove records from Salesforce.
 *
 * Users of this class can expect to gain a strong understanding of DML operations in Apex and
 * be prepared for more advanced topics in Salesforce development.
 * 
 * The methods within this class serve as practical examples of different DML operations, 
 * allowing developers to learn through practice and examples.
 * 
 * @author Your Name
 * @version 1.0
 */


public with sharing class DMLOperations {
    /**
     * This method creates a new Account object and inserts it into the database.
     * The Account will have a random name for uniqueness.
     *
     * @return The Id of the newly created Account.
     */
    public static Id insertNewAccount() {
        // Create a new Account instance
        Account newAccount = new Account();

        // Set some fields on the Account
        newAccount.Name = 'Account-' + DateTime.now().getTime();

        // Insert the Account into the database
        insert newAccount;

        // Return the Id of the newly created Account
        return newAccount.Id;
    }

    /**
     * This method creates a new Account with the specified name and industry.
     *
     * @param name The name of the account to be created.
     * @param industry The industry of the account to be created.
     */
    public static void createAccount(String name, String industry) {
        // Create a new Account
        Account acc = new Account(Name = name, Industry = industry);

        // Insert the Account
        insert acc;
    }

    
    /**
     * This method creates a new Contact object linked to an existing Account and inserts it into the database.
     *
     * @param accountId The Id of the Account to link the Contact to.
     * @return The Id of the newly created Contact.
     */
    public static Id insertNewContact(Id accountId) {
        // Create a new Contact instance
        Contact newContact = new Contact();

        // Set some fields on the Contact
        newContact.LastName = 'Doe-' + DateTime.now().getTime();
        newContact.AccountId = accountId;

        // Insert the Contact into the database
        insert newContact;

        // Return the Id of the newly created Contact
        return newContact.Id;
    }

    /**
     * This method updates the last name of a Contact in the database.
     *
     * @param contactId The Id of the Contact to update.
     * @param newLastName The new last name for the Contact.
     */
    public static void updateContactLastName(Id contactId, String newLastName) {
        // Retrieve the Contact from the database
        Contact contactToUpdate = [SELECT Id, LastName FROM Contact WHERE Id = :contactId];

        // Update the Contact's last name
        contactToUpdate.LastName = newLastName;

        // Update the Contact in the database
        update contactToUpdate;
    }

    /**
     * This method updates the stage of an Opportunity in the database.
     *
     * @param oppId The Id of the Opportunity to update.
     * @param newStage The new stage for the Opportunity.
     */
    public static void updateOpportunityStage(Id oppId, String newStage) {
        // Retrieve the Opportunity from the database
        Opportunity oppToUpdate = [SELECT Id, StageName FROM Opportunity WHERE Id = :oppId];

        // Update the Opportunity's stage
        oppToUpdate.StageName = newStage;

        // Update the Opportunity in the database
        update oppToUpdate;
    }

    /**
     * This method updates the Account's Name and Industry given an Account Id.
     *
     * @param accountId The Id of the account to be updated.
     * @param newName The new name for the account.
     * @param newIndustry The new industry for the account.
     */
    public static void updateAccountFields(Id accountId, String newName, String newIndustry) {
        // Query the account
        Account acc = [SELECT Id, Name, Industry FROM Account WHERE Id = :accountId];

        // Update the Account fields
        acc.Name = newName;
        acc.Industry = newIndustry;

        // Update the Account
        update acc;
    }


    /**
     * This method creates or updates an Opportunity related to an Account.
     * The Opportunity's Name is the same as the Account's Id.
     * The Opportunity's Stage is set to Prospecting.
     * The Opportunity's Close Date is set to 3 months from today.
     *
     * @param accountId The Account Id related to the Opportunity.
     */
    public static void upsertOpportunityForAccount(Id accountId) {
        // Prepare an Opportunity for the Account
        Opportunity opp = new Opportunity(Name = String.valueOf(accountId), AccountId = accountId, StageName = 'Prospecting', CloseDate = Date.today().addMonths(3));

        // Upsert the Opportunity using the Name as the key
        upsert opp Name;
    }

    /**
     * This method upserts a list of Opportunities under a specified Account. 
     * There should be an Opportunity for each name provided.
     *
     * @param accountName The name of the Account.
     * @param oppNames The list of Opportunity names.
     */
    public static void upsertOpportunities(String accountName, List<String> oppNames) {
        // Prepare an Account with the given name
        Account account = new Account(Name = accountName);
        
        // Upsert the Account
        upsert account;
        
        // Prepare a List to store the Opportunities
        List<Opportunity> opportunities = new List<Opportunity>();

        // Loop through each Opportunity name
        for (String name : oppNames) {
            // Create an Opportunity with the given name
            Opportunity opp = new Opportunity(Name = name, StageName = 'Prospecting', CloseDate = Date.today().addDays(30), AccountId = account.Id);
            
            // Add the Opportunity to the list
            opportunities.add(opp);
        }

        // Upsert the Opportunities
        upsert opportunities;
    }

    /**
     * This method takes a list of contacts and their corresponding account names, upserts the accounts,
     * links the contacts to the accounts, and then upserts the contacts.
     * Links the records by the last letter of the contact's last name and the account name.
     * Example - Contact: John Doe 1, Account: Doe Inc. 1
     *
     * @param contactsToUpsert List of Contacts to be upserted.
     * @param accountNames List of Account names corresponding to the Contacts.
     */
    public static void upsertAccountsWithContacts(List<Contact> contactsToUpsert, List<String> accountNames) {
        // Prepare a map to link Account Names with their Ids
        Map<String, Id> accountNameToIdMap = new Map<String, Id>();

        // Prepare a list to store the Accounts
        List<Account> accounts = new List<Account>();

        // Loop through each Account name
        for (String name : accountNames) {
            // Create an Account with the given name
            Account account = new Account(Name = name);
            
            // Add the Account to the list
            accounts.add(account);
        }

        // Upsert the Accounts
        upsert accounts;

        // Loop through each upserted Account
        for (Account account : accounts) {
            // Put the Account Name and Id in the map
            accountNameToIdMap.put(account.Name.split('')[account.Name.length() - 1], account.Id);
        }

        // Loop through each Contact
        for (Contact contact : contactsToUpsert) {
            // Link the Contact to its Account
            System.debug(contact);
            System.debug(contact.LastName.split('')[contact.LastName.length() - 1]);

            contact.AccountId = accountNameToIdMap.get(contact.LastName.split('')[contact.LastName.length() - 1]);
        }

        // Upsert the Contacts
        upsert contactsToUpsert;
    }


    /**
     * This method inserts a list of Leads and then deletes them.
     *
     * @param leadNames The list of Lead names to be inserted.
     */
    public static void insertAndDeleteLeads(List<String> leadNames) {
        // Prepare a List to store the Leads
        List<Lead> leads = new List<Lead>();

        // Loop through each Lead name
        for (String name : leadNames) {
            // Create a Lead with the given name
            Lead lead = new Lead(LastName = name, Company = 'Test Company');
            
            // Add the Lead to the list
            leads.add(lead);
        }

        // Insert the Leads
        insert leads;

        // Delete the Leads
        delete leads;
    }


    /**
     * This method creates a number of cases for the given accountId, then deletes them.
     *
     * @param accountId The account for which the cases will be created and then deleted.
     * @param numOfCases The number of cases to create.
     */
    public static void createAndDeleteCases(String accountId, Integer numOfCases) {
        // Create a list to hold the new cases
        List<Case> casesToCreate = new List<Case>();

        // Loop to create the specified number of cases
        for (Integer i = 0; i < numOfCases; i++) {
            // Create a new case and add it to the list
            Case c = new Case(Subject = 'Case ' + i, AccountId = accountId);
            casesToCreate.add(c);
        }

        // Insert the cases
        insert casesToCreate;

        // Delete the cases
        delete casesToCreate;
    }
}