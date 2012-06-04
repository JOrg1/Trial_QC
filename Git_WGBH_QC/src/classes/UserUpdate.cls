public class UserUpdate {

    Public PageReference updateUser(){
        id id1 = ApexPages.CurrentPage().getParameters().get('id');
        User usr = new User(id = id1);
        string ln = ApexPages.CurrentPage().getParameters().get('lname');
        string fn = ApexPages.CurrentPage().getParameters().get('fname');
        string al = ApexPages.CurrentPage().getParameters().get('alias');
        string tit = ApexPages.CurrentPage().getParameters().get('title');
        if(ln != null)
        usr.LastName = ln;
        usr.FirstName = fn;
        if(al != null)
        usr.alias = al;
        usr.title = tit;
        update usr;
        return null;
    }

}