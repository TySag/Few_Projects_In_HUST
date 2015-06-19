using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.IO;
using System.Threading;
using System.Net;
using System.Net.Mail;
using System.Runtime.InteropServices;
using System.Configuration;

namespace 华科欢乐多
{
    public partial class Form2 : Form
    {
        public string path;
        huakeplay userimf = new huakeplay();
        [DllImport("kernel32")]
        private static extern long WritePrivateProfileString(string section,
            string key, string val, string filePath);
        [DllImport("kernel32")]
        private static extern int GetPrivateProfileString(string section,
                 string key, string def, StringBuilder retVal,
            int size, string filePath);
        public Form2()
        {
            InitializeComponent();
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            zhucemamake();
            textBox2.PasswordChar=textBox3.PasswordChar='*';
        }
        private void zhucemamake() {
            Random random = new Random();
            int a = Convert.ToInt32(random.Next(0, 10));
            int b = Convert.ToInt32(random.Next(0, 25));
            int c = Convert.ToInt32(random.Next(0, 10));
            int d = Convert.ToInt32(random.Next(0, 25));
            label6.TextAlign = ContentAlignment.MiddleCenter;
            label6.Text = " " + a.ToString() + " "+((char)(b+'a')).ToString()  + " " + c.ToString() + " "+((char)('a'+d)).ToString();
            textBox5.Text = "";
        }
        private void button2_Click(object sender, EventArgs e)
        {
            textBox1.Text = textBox2.Text = textBox3.Text = textBox4.Text = textBox5.Text = "";
            zhucemamake();
        }

        private void button1_Click(object sender, EventArgs e)
        {
          //  label6;
            string[] str=label6.Text.Split(' ');
            path = "user//" + textBox1.Text + ".ini";
            if (textBox5.Text != str[1] + str[2] + str[3] + str[4])
            {
                MessageBox.Show("验证码出错");
            }
            else {
                if (File.Exists(path))
                {
                    MessageBox.Show("用户名已存在");
                }
                else {
                    if (textBox2.Text.Length < 6)
                    {
                        MessageBox.Show("密码长度不够");
                    }
                    else
                    {
                        if (textBox3.Text != textBox2.Text)
                        {
                            MessageBox.Show("两次输入密码不一样");
                        }
                        else
                        {
                            if (IsEmail(textBox4.Text) == true)
                            {
                                sendmailtoyou();
                                Createuser();
                            }
                            else
                            {
                                MessageBox.Show("邮箱格式不正确或邮箱不存在");
                            }
                        }
                    }
                }
            } 
            zhucemamake();
        }
        private void Createuser() {
            File.Create(path);
            WritePrivateProfileString("userbase","password", textBox2.Text, path);
            WritePrivateProfileString("userbody", "can", "", path);
        }
        private void button3_Click(object sender, EventArgs e)
        {
            zhucemamake();
        }
        public bool IsEmail(string str_Email)
        {
            return System.Text.RegularExpressions.Regex.IsMatch(str_Email,
  @"^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$");
        }
        private void sendmailtoyou()
        {
            MailMessage Mail = new MailMessage();
            //  sc.Timeout = 9999;
            Mail.From = new MailAddress("1394371281@qq.com");
            Mail.To.Add(new MailAddress(textBox4.Text));
            Mail.Subject = "华科欢迎你 ";
            Mail.IsBodyHtml = true;//.Trim().ToString()
            Mail.Body = "欢迎来到华科欢乐多~~~";//华科介绍 链接
            Mail.BodyEncoding = System.Text.Encoding.UTF8;
            Mail.Priority = MailPriority.High;
            SmtpClient sc = new SmtpClient();
            sc.Credentials = new NetworkCredential("1394371281@qq.com", "tyskfs");
            sc.Host = "smtp.qq.com";
            sc.Port = 25;
            //   sc.UseDefaultCredentials = true;
            sc.EnableSsl = false;
            sc.Send(Mail);
            MessageBox.Show("当前角色属性已确定，恭喜注册成功且一封邮件已送到你的邮箱   ");
        }

        private void button4_Click(object sender, EventArgs e)
        {
            shuxingguihua();
        }
        private void shuxingguihua() {
            userimf.ableattack = new ability();
            userimf.ableattack.nable = 0;
            userimf.bagpage = new bagkeep();
            userimf.bagpage.thing[0] = new Thingzhi();
            userimf.bagpage.thing[1] = new Thingzhi();
            userimf.bagpage.thing[0].thingname = "体力丸";
            userimf.bagpage.thing[0].thinglevel = 0;
            userimf.bagpage.thing[0].thingintroduce = "回复20点体力";
            userimf.bagpage.thing[0].thingnumber = 10;
            userimf.bagpage.thing[1].thingname = "补脑丸";
            userimf.bagpage.thing[1].thinglevel = 0;
            userimf.bagpage.thing[1].thingintroduce = "回复15点脑力";
            userimf.bagpage.thing[1].thingnumber = 10;
        }
    }
}
