using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using MySql.Data.MySqlClient;


namespace Car
{
    public partial class Login : Form
    {
        public Users user;
        public Staffs staff;
        public bool power;
        public bool success;
        MySqlHelper sqlhelper = null;
        bool Regable = false;
        static string poweruser = "poweruser";
        static string powerpwd = "123456";
        static string sysdatabase = "car";
        public Login()
        {
            InitializeComponent();
            ID_LEVEL.SelectedIndex = 0;
            if (!Regable)
            {
                MailBox.ReadOnly = true;
            }
            power = false;//User
            success = false;//not login
        }
        //signin
        private void Sign_Click(object sender, EventArgs e)
        {
            ID_LEVEL.Enabled = false;
            Cancel.Enabled = false;
            //UserBox.Text = "admin";// "zsf"; //
            //PassBox.Text = "admin";// "123456";//
            //ID_LEVEL.SelectedIndex = 1;
            if(UserBox.Text=="") {
                MessageBox.Show("User is NULL");
                return ;
            }
            if(PassBox.Text==""){
                MessageBox.Show("Pass is NULL");
                return ;
            }
            if (Regable && MailBox.Text == "")
            {
                MessageBox.Show("Mail is NULL");
                return ;
            } 
            success = Regable ? RegSql() : SignSql(); 
            ID_LEVEL.Enabled = true;
            Cancel.Enabled = true;
            if (success)
            {//back to the main form
                this.Close();
            }
        }
        private bool SignSql(){
            sqlhelper = new MySqlHelper(poweruser, powerpwd, sysdatabase);
            if (sqlhelper.Connect())
            {
                string sqlword;
                if (ID_LEVEL.SelectedIndex == 0) //user
                {
                    sqlword = "select * from " + ID_LEVEL.Text;
                    sqlword += " where uid = " + addstring(UserBox.Text);
                }
                else
                {                      
                    sqlword = "select * from " + ID_LEVEL.Text;
                    sqlword += " where sid = " + addstring(UserBox.Text);
                }
                MySqlDataReader sqlR = sqlhelper.ExecuteReader(sqlword);
                if (sqlR == null){
                    MessageBox.Show("服务器抛出异常");
                    return false;
                }
                if (sqlR.Read())
                {
                    if (sqlR.FieldCount == 4)//staff
                    {
                        staff = new Staffs();
                        staff.Sid = sqlR[0].ToString();
                        staff.Pass = sqlR[1].ToString();
                        staff.Name = sqlR[2].ToString();
                        staff.Pos = sqlR[3].ToString();
                        if (staff.Pass == PassBox.Text)
                        {
                            power = true;
                            return true;
                        }
                        else
                        {
                            MessageBox.Show("口令错误");
                            return false;
                        }
                    }
                    else if (sqlR.FieldCount == 7)//user
                    {
                        user = new Users();
                        user.Uid = sqlR[0].ToString();
                        user.Pass = sqlR[1].ToString();
                        user.Name = sqlR[2].ToString();
                        user.Mail = sqlR[3].ToString();
                        user.Phone = sqlR[4].ToString();
                        user.Address = sqlR[5].ToString();
                        user.Blacklabel = (bool)sqlR[6];
                        if (user.Pass == PassBox.Text)
                        {
                            power = false;
                            return true;
                        }
                        else
                        {
                            MessageBox.Show("口令错误");
                            return false;
                        }
                    }
                    else
                    {
                        MessageBox.Show("没有该 "+ID_LEVEL.Text);
                    }
                    sqlR.Close();
                    sqlR.Dispose();
                    sqlhelper.Close();
                    sqlhelper.Dispose();
                    return false;
                }
            }
            else
            { 
                MessageBox.Show("failed to connect");
                return false;
            }
            MessageBox.Show("没有该 " + ID_LEVEL.Text);
            return false;
        }
        string addstring(string word)
        {
            return "'"+word+"'";
        }
        private bool RegSql(){  
            string sqlword;
            sqlhelper = new MySqlHelper(poweruser, powerpwd, sysdatabase);
            if (sqlhelper.Connect())
            {
                sqlword = "select * from users";
                sqlword += " where uid = " + addstring(UserBox.Text) + "";
                MySqlDataReader sqlR = sqlhelper.ExecuteReader(sqlword);
                if (sqlR == null)
                {
                    MessageBox.Show("服务器抛出异常");
                    return false;
                }
                else if (!sqlR.Read())
                {
                    user.Uid = UserBox.Text;
                    user.Pass = PassBox.Text;
                    user.Name = "";
                    user.Mail = MailBox.Text;
                    user.Phone = "";
                    user.Address = "";
                    user.Blacklabel = false;
                    sqlword = "insert into users values (" + addstring(user.Uid);
                    sqlword += "," + addstring(user.Pass);
                    sqlword += "," + addstring(user.Name);
                    sqlword += "," + addstring(user.Mail);
                    sqlword += "," + addstring(user.Phone);
                    sqlword += "," + addstring(user.Address);
                    sqlword += ",false)";
                    try
                    {
                        sqlhelper.ExecuteSql(sqlword);
                        MessageBox.Show("创建用户成功，现跳转到主界面");
                        power = false;
                        return true;
                    }
                    catch
                    {
                        MessageBox.Show("创建用户失败");
                        return false;
                    }
                }
                MessageBox.Show("该用户已经存在");
                return false;
            }
            else
            {
                MessageBox.Show("failed to connect");
                return false;
            }
        }
        //Rsg
        private void Reg_Click(object sender, EventArgs e)
        {
            if (Regable){
                Regable = false;
                MailBox.ReadOnly = true;
                MailBox.Text = "注册填写";
                Reg.Text = "注册";
                ID_LABEL.Text = "登陆身份";
                ID_LEVEL.Enabled = true;
            }
            else{
                Regable = true;
                MailBox.ReadOnly = false;
                MailBox.Text = "";
                Reg.Text = "退出注册";
                ID_LABEL.Text = "注册身份";
                ID_LEVEL.SelectedIndex = 0;
                ID_LEVEL.Enabled = false;
            }
        }

        private void Cancel_Click(object sender, EventArgs e)
        {
            if (sqlhelper != null)
            {
                sqlhelper.Close();
                sqlhelper.Dispose();
            }
            this.Close();
        }
    
    }
}
