using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Xml;

namespace 终了时MusicBox
{
    public partial class askformusic : Form
    {
        string wwwfind = "";
        string sousongname = Form1.ssname;
        public static string strlrc = "";
        public static string strpath = ""; 
        string strEncode = "";
        string strDecode = "";
        string strExt = "";
        string[] Strsong; 
        public askformusic()
        {
            InitializeComponent();
            this.BackgroundImage = Image.FromFile(Form1.beijing);
        }
        private void beginfindsong()
        {
            try
            {
                wwwfind = Getitinhttp(sousongname);
                if (wwwfind == "nothing")
                {
                    //改变背景
                }
                else
                {
                    Strsong = wwwfind.Split(" ".ToCharArray());
                    strEncode = Strsong[0].ToString();            //编码  
                    strDecode = Strsong[1].ToString();            //解码  
                    strExt = Strsong[2].ToString();               //扩展名  
                    strlrc = Strsong[3].ToString();               //歌词URL  
                    strpath = Strsong[4].ToString();              //歌曲URL 
                    button3.Text = "搜索完毕!";
                    label1.Text = label1.Text + sousongname + ":" + "\n\n\n" + "歌曲信息:" + strpath + "\n\n" + "歌词信息:" + strlrc + "\n\n" + "该结果由百度音乐提供            ";

                }
            }
            catch
            {
                MessageBox.Show("找不到音乐 " + sousongname + " 请更换查询名称");
            }  
        }
        private string Getitinhttp(string song) 
        { 
            try{
            string strAPI="http://mp3.baidu.com/m?gate=0&z=0&cl=3&ct=671088640&sn="+"&lm=0&cm=1&sc=1&bu=&rn=30&tn=baidump3&word=" + song + "&pn=1" ;
                //"http://box.zhangmen.baidu.com/x?op=12&count=1&title=";
            strAPI=strAPI+song;
            XmlTextReader html=new XmlTextReader(strAPI);
            DataSet ds=new DataSet();
            ds.ReadXml(html);
            string strDecode=ds.Tables["date"].Rows[0]["decode"].ToString().Replace("\n","");
            string strEncode = ds.Tables["data"].Rows[0]["encode"].ToString().Replace("\n", "");
            string strLrc = ds.Tables["data"].Rows[0]["lrcid"].ToString().Replace("<br />", "");
            string strPath = "";
            string strExt = "";
            string[] strPre = strEncode.Split("/".ToCharArray());
            strPath = strEncode.Replace(strPre[strPre.Length - 1], strDecode);          //赋值MP3真正地址  
            string strLrcPath = "http://box.zhangmen.baidu.com/bdlrc/";                 //歌词基本地址  
            if (strLrc == "0")
            {  
                strLrc = "暂无歌词";
            } 
            else
            {  
                strLrc = strLrcPath + (Int32.Parse(strLrc) / 100).ToString() + "/" + strLrc + ".lrc";  
            }
            switch (ds.Tables["data"].Rows[0]["type"].ToString())  
            {  
                case "1":  
                    strExt = "rm";
                    break; 
                case "0":  
                    strExt = "mp3";  
                    break;  
                case "2":  
                    strExt = "wma";  
                    break;  
            }  
            if (strEncode == "nothing")  
            {  
                return "nothing";  
            } 
            return strEncode + " " + strDecode + " " + strExt + " " + strLrc + " " + strPath;
            }
            catch{
                return "nothing";//Getitinhttp(song); 
            }
        }

        private void askformusic_KeyUp(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.F5)
            {
                beginfindsong();
            }
        }

        private void button3_Click(object sender, EventArgs e)
        {
            DialogResult dr = MessageBox.Show("该结果由百度音乐提供            ", "提示", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
            if (dr == DialogResult.Yes)
            {
                button3.Text = "搜索中，请稍等...";
                beginfindsong();
            }
        }
    }
}
