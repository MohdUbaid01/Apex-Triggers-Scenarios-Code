//Trigger Practice 1 by Mohd Ubaid, /* Just Sit back Relax and Code 😎
//Problem Statement
/*----------------------------*/
/*---------------------------*/
    
     /* Updates phone numbers of Contacts Jab the Account phone number changes.
     *
     * @param newAccounts List of updated Account records (Trigger.new) , jo updated ho chuke he
     * @param oldAccountMap Map of old Account records (Trigger.oldMap), Jo Update se Phle he
     */

    public static void updateContactPhones(List<Account> newAccounts, Map<Id, Account> oldAccountMap) {
        // Map to hold accounts with changed phone numbers
        Map<Id, String> updatedAccountPhones = new Map<Id, String>();
        
        // Identify accounts where the phone number has changed
        for (Account acc : newAccounts) {
            if (acc.Phone != oldAccountMap.get(acc.Id).Phone) {
                updatedAccountPhones.put(acc.Id, acc.Phone);
            }
        }
        
        // Exit if no phone numbers were updated
        if (updatedAccountPhones.isEmpty()) {
            return;
        }
        
        // Fetch related contacts whose phone numbers need to be updated
        List<Contact> contactsToUpdate = new List<Contact>();
        for (Contact con : [
            SELECT Id, AccountId, Phone 
            FROM Contact 
            WHERE AccountId IN :updatedAccountPhones.keySet()
        ]) {
            String updatedPhone = updatedAccountPhones.get(con.AccountId);
            if (con.Phone != updatedPhone) {
                con.Phone = updatedPhone;
                contactsToUpdate.add(con);
            }
        }
        
        // Update contacts if any changes were made
        if (!contactsToUpdate.isEmpty()) {
            update contactsToUpdate; // Avoid Bulkification
        }
    }

/*-------------------------------------------------------------------*/

    /*Trigger Handler Class */
    trigger AccountTrigger on Account (after update) {
    if (Trigger.isAfter && Trigger.isUpdate) {
        AccountTriggerHandler.updateContactPhones(Trigger.new, Trigger.oldMap);
    }
}