using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.IO;

namespace 百万亚瑟忙
{
    public partial class Form1 : Form
    {
        public List<YaSeKind> All = new List<YaSeKind>();
        public YaSeKind Log = new YaSeKind();
        public YaSeKind Now = new YaSeKind();
        public Form1()
        {
            InitializeComponent();
            FindAllKind();
        }
        private void FindAllKind(){
            String path = "conf\\User";
            String re;
            if (!Directory.Exists(path))
                return;
            else
            {
                String[] k = Directory.GetFiles(path, "*.YSK");
                if (k.Length == 0)
                    return;
                foreach (String s in k)
                {
                    StreamReader sr = new StreamReader(s, System.Text.Encoding.Default, false);
                    re = sr.ReadLine();
                    Now=new YaSeKind();
                    String[] r = re.Split('*');
                    Now.NameID = r[0];
                    Now.ID = r[1];
                    Now.PW = r[2];
                    Now.area = Convert.ToInt32(r[3]);
                    Com.Items.Add(Now.NameID);
                    All.Add(Now);
                    sr.Close();
                    sr.Dispose();
                }
            }
        }
        bool AddT = true;
        private void AddCount_Click(object sender, EventArgs e)//添加一个账号
        {
            if (AddT == true)
            {
                Login.Visible = true;
                AddCount.Text = "取消添加";
                AddT = false;
            }
            else
            {
                Login.Visible = false;
                AddCount.Text = "添加账号";
                AddT = true;
            }
        }
        private void button1_Click(object sender, EventArgs e)
        {
            Log.ID=LoginID.Text;
            Log.PW=LoginPW.Text;
            Log.area = Area.SelectedIndex;
            if (Log.ID.Length == 11 && Log.PW != null)
            {
                if (Log.LoginToSD() == true)
                {
                    All.Add(Log);
                    Login.Visible = false;
                    if (Remb.Checked)
                    {
                        StreamWriter sw = new StreamWriter("\\conf\\User\\"+Log.ID+".YSK");
                        sw.WriteLine(Log.NameID+"*"+Log.ID+"*"+Log.PW+"*"+Log.area.ToString());
                        sw.Close();
                        sw.Dispose();
                    }
                }
                else
                {
                    MessageBox.Show("登陆失败~~~~~~！");
                }
            }
            else
            {
                MessageBox.Show("账号输入格式不正确或没有输入密码");
            }
        }
        private void Com_SelectedIndexChanged(object sender, EventArgs e)
        {
            if(Com.SelectedIndex==-1)
                return;
            Now = new YaSeKind();
            Now.NameID = Com.SelectedItem.ToString();
            foreach (YaSeKind f in All)
            {
                if (f.NameID == Now.NameID)
                {
                    Now.ID = f.ID;
                    Now.ID = f.PW;
                    if (Now.LoginToSD())
                    {
                        return;
                    }
                    else
                    {
                        MessageBox.Show("账号信息已改或登陆失败，请重试");
                        Com.SelectedIndex = -1;
                        return;
                    }
                }
            }
            MessageBox.Show("没有找到该账号信息，请检查");
        }
    }
}
