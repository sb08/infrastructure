namespace api.Messages;

public class Registration
{
    public string FirstName { get; }
    public string LastName { get; }
    public string Email { get; }
    public string UserType { get; }
    public string Origin { get; }
    public string Date { get; }

    public Registration(string firstName, string lastName, string email, string userType, string origin, string date)
    {
        FirstName = firstName;
        LastName = lastName;
        Email = email;
        UserType = userType;
        Origin = origin;
        Date = date;
    }
}