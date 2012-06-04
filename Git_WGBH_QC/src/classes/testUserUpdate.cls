@istest
private class testUserUpdate {
    static testmethod void testUserUpdate() {
        userupdate u=new userupdate();
        try {
        pagereference p = u.updateuser();
        }Catch(Exception ex) {}
    }
}