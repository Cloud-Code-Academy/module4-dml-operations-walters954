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

        // Set some fields on the Account

        // Insert the Account into the database

        // Return the Id of the newly created Account
        return null;
    }

    /**
     * This method creates a new Account with the specified name and industry.
     *
     * @param name The name of the account to be created.
     * @param industry The industry of the account to be created.
     */
    public static void createAccount(String name, String industry) {
        // Create a new Account and set the fields inline

        // Insert the Account
    }

    
    /**
     * This method creates a new Contact object linked to an existing Account and inserts it into the database.
     *
     * @param accountId The Id of the Account to link the Contact to.
     * @return The Id of the newly created Contact.
     */
    public static Id insertNewContact(Id accountId) {
        // Create a new Contact instance

        // Set some fields on the Contact
        // Set the AccountId field to the given accountId

        // Insert the Contact into the database

        // Return the Id of the newly created Contact
        return null;
    }

    /**
     * This method updates the last name of a Contact in the database.
     *
     * @param contactId The Id of the Contact to update.
     * @param newLastName The new last name for the Contact.
     */
    public static void updateContactLastName(Id contactId, String newLastName) {
        // Retrieve the Contact from the database

        // Update the Contact's last name

        // Update the Contact in the database
    }

    /**
     * This method updates the stage of an Opportunity in the database.
     *
     * @param oppId The Id of the Opportunity to update.
     * @param newStage The new stage for the Opportunity.
     */
    public static void updateOpportunityStage(Id oppId, String newStage) {
        // Retrieve the Opportunity from the database

        // Update the Opportunity's stage

        // Update the Opportunity in the database
    }

    /**
     * This method updates the Account's Name and Industry given an Account Id.
     *
     * @param accountId The Id of the account to be updated.
     * @param newName The new name for the account.
     * @param newIndustry The new industry for the account.
     */
    public static void updateAccountFields(Id accountId, String newName, String newIndustry) {
        // Update the Account with the given Id with the new name and industry
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
        // Set the Opportunity's Name to the Account's Id
        // Set the Opportunity's Stage to Prospecting
        // Set the Opportunity's Close Date to 3 months from today

        // Upsert the Opportunity
    }

    /**
     * This method upserts a list of Opportunities under a specified Account. 
     * There should be an Opportunity for each name provided.
     *
     * @param accountName The name of the Account.
     * @param oppNames The list of Opportunity names.
     */
    public static void upsertOpportunities(String accountName, List<String> oppNames) {
        // Loop through each Opportunity name
            // Create an Opportunity with the given name
            // Add the Opportunity to the list
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
        // Loop through each Account name

        // Upsert the Accounts

        // Loop through each upserted Account
            // Add the Account's Id to a Map with the last letter of the Account's name as the key 

        // Loop through each Contact
            // Set the AccountId of the Contact to the Id of the Account with the same last letter of the Contact's last name

        // Upsert the Contacts
    }


    /**
     * This method inserts a list of Leads and then deletes them.
     *
     * @param leadNames The list of Lead names to be inserted.
     */
    public static void insertAndDeleteLeads(List<String> leadNames) {
        // Loop through each Lead name

        // Insert the Leads

        // Delete the Leads
    }


    /**
     * This method creates a number of cases for the given accountId, then deletes them.
     *
     * @param accountId The account for which the cases will be created and then deleted.
     * @param numOfCases The number of cases to create.
     */
    public static void createAndDeleteCases(String accountId, Integer numOfCases) {
        // Insert the cases

        // Delete the cases
    }
}