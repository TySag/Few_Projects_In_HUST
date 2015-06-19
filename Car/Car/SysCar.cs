using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Car
{
    public struct Users
    {
        public string Uid;
        public string Pass;
        public string Name;
        public string Mail;
        public string Phone;
        public string Address;
        public bool Blacklabel;
        public Users(Users users)
        {
            // TODO: Complete member initialization
            this.Uid = users.Uid;
            this.Pass = users.Pass;
            this.Name = users.Name;
            this.Mail = users.Mail;
            this.Phone = users.Phone;
            this.Address = users.Address;
            this.Blacklabel = users.Blacklabel;
        }
    }
    public struct CarsInfo
    {
        public string Name;
        public string Brand;
        public int Life;
        public int Popular;
        public int Totalnum;
        public int Availnum;
    }
    public struct Cars
    {
        public string Cid;
        public string Name;
        public int Price;
        public int Deposit;
        public int Speed;
        public int Days;
        public string State;
    }
    public struct Staffs
    {
        public string Sid;
        public string Pass;
        public string Name;
        public string Pos;
        public Staffs(Staffs staff)
        {
            // TODO: Complete member initialization
            this.Sid = staff.Sid;
            this.Pass = staff.Pass;
            this.Name = staff.Name;
            this.Pos = staff.Pos;
        }
    }
    public struct Orders
    {
        string Oid;
        string Cid;
        string Uid;
        int Days;
    }
    public struct Records
    {
        string Rid;
        string Cid;
        string Uid;
        string Sid;
        DateTime Date;
        int Days;
        int Cost;
    }
    public struct Fixlist
    {
        string Fid;
        string Rid;
        string Fix;
        int Cost;
    }
    public struct Accident
    {
        string Aid;
        string Rid;
        string Acc;
        int Cost;
    }
    
    
}
