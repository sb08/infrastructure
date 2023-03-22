using System.ComponentModel.DataAnnotations;

namespace api.Domain
{
    public class Broker
    {
        [Key]
        public int Id { get; set; }
        public string FirstName { get; }
        public string LastName { get;  }
        public string Email { get; }
        public string UserType { get; }

        public Broker(string firstName, string lastName, string email, string userType)
        {
            FirstName = firstName;
            LastName = lastName;
            Email = email;
            UserType = userType;
        }

        public Broker()
        {

        }
    }
}