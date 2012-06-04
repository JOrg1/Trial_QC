public class BioSaveURL {
    Public PageReference RedirectTo() {
        String RedirectURL = ApexPages.currentPage().getParameters().get('ParentID');
        if(RedirectURL==null || RedirectURL =='') {
            RedirectURL = ApexPages.currentPage().getParameters().get('newid');
        }
        PageReference P = new PageReference('/' + RedirectURL);
        P.SetRedirect(True);
        return P;
    }
}