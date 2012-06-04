/*** Controller ***/
public class exampleCon {
    String uname;

    public String getUsername() {
        return uname;
    }
            
    public PageReference sayHello() {
        uname = UserInfo.getName();
        return null;
    }
            
    public void setState(String n) {
        state = n;
    }
            
    public String getState() {
        return state;
    }
            
    public PageReference methodOne() {
        return null;
    }
            
    private String state = 'no';
    
    static testMethod void TestexampleCon() {
        Test.startTest();
        exampleCon eCon = new exampleCon();
        eCon.getUsername();
        eCon.getState();
        eCon.setState('AZ');
        eCon.methodOne();
        eCon.sayHello();
        
        Test.StopTest();   
    }   
}