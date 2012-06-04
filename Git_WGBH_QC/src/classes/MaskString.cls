public class MaskString {
    public string cMaskString{get;set;}
    public string cMaskChar{get;set;}
    public integer cNoOfVisibleChar{get;set;}
    
    
    public string getDisplayMaskString() {
        if(cMaskString==null) cMaskString = '';
        if(cMaskChar==null) cMaskChar= 'X';
        if(cNoOfVisibleChar==null) cNoOfVisibleChar = 4;
        return commonApex.getMaskedString(cMaskString,cMaskChar,cNoOfVisibleChar);
    }
    
    public static testmethod void TestMastString() {
        MaskString clstest = new MaskString();
        clsTest.getDisplayMaskString();
    }
}