@isTest
Private class TestBioSaveURL 
{ 
static testMethod void TestBioSaveURL () 
{
    BioSaveURL b=new BioSaveURL ();
    PageReference P=b.RedirectTo();
}
}