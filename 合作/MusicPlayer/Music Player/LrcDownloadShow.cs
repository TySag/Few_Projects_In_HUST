using System;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;
using System.IO;
using System.Windows.Forms;
using System.Threading;
using System.Net;
using System.Web;

namespace MusicPlayer
{
    class LrcDownload
    {
        public static WebClient client = new WebClient();  
        public static void gecixia(string name)  
        {  
            //string geci_search_adress = HttpUtility.UrlEncode(name, Encoding.Default);  
            //string ci = geci_search_adress;  
            //string geci = "http://mp3.sogou.com/gecisearch.so?query=" + ci + "&as=false&st=&ac=1&pf=&class=5&gecisearch.so=";  
           
            //string ne = GetWebContent(geci);  
             
            //Regex r2 = new Regex("((downlrc.jsp?).*(LRC歌词下载))", RegexOptions.IgnoreCase);  
            
            //if (r2.IsMatch(ne))  
            //{  
                 
            //    string wangzhi = r2.Match(ne).Value;  
            //    string down_address = "http://mp3.sogou.com/" + wangzhi.Remove(wangzhi.IndexOf('"'));  
            //    DownloadFile(down_address, System.AppDomain.CurrentDomain.BaseDirectory + "Lrc//" + name + ".lrc");  
               
            //}  
            //else  
            //{  
            //    Regex r3 = new Regex("http://.*(?=.*lrc/");  
            //    if (r3.IsMatch(ne))  
            //    {  
            //        string wangzhi1 = r3.Match(ne).Value;  
                    
                      
            //        string down_address1 = "http://mp3.sogou.com/" + wangzhi1.Remove(wangzhi1.IndexOf('"'));  
            //        client.Dispose();  
            //        DownloadFile( down_address1, System.AppDomain.CurrentDomain.BaseDirectory + "Lrc//" + name + ".lrc");  
            //    }  
            //    else  
            //    {  
            //        Regex r4 = new Regex(@"lrc.aspxp.net/lrc.asp.* ");  
            //        if (r4.IsMatch(ne))  
            //        {  
            //            string wangzhi2 = r2.Match(ne).Value;  
            //            string down_address2 = wangzhi2.Remove(wangzhi2.IndexOf('"'));  
            //            DownloadFile("http://" + down_address2, System.AppDomain.CurrentDomain.BaseDirectory + "Lrc//" + name + ".lrc");  
            //        }  
            //    }  
            //}  
        }  
        public static string GetWebContent(string Url)  
        {  
            string strResult = "";  
            try  
            {  
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(Url);  
                //声明一个HttpWebRequest请求   
                request.Timeout = 30000;  
                //设置连接超时时间   
                request.Headers.Set("Pragma", "no-cache");  
                HttpWebResponse response = (HttpWebResponse)request.GetResponse();  
                Stream streamReceive = response.GetResponseStream();  
                Encoding encoding = Encoding.GetEncoding("GB2312");  
                StreamReader streamReader = new StreamReader(streamReceive, encoding);  
                strResult = streamReader.ReadToEnd();  
            }  
            catch  
            {  
                // MessageBox.Show("出错");   
            }  
            return strResult;  
        }  
        public static void DownloadFile(string URLAddress, string fileName)  
        {  
            try  
            {  
                client.DownloadFile(URLAddress, fileName);  
                Stream str = client.OpenRead(URLAddress);  
                StreamReader reader = new StreamReader(str);  
                byte[] mbyte = new byte[1000000];  
                int allmybyte = (int)mbyte.Length;  
                int startmbyte = 0;  
                while (allmybyte > 0)  
                {  
                    int m = str.Read(mbyte, startmbyte, allmybyte);  
                    if (m == 0)  
                        break;  
                    startmbyte += m;  
                    allmybyte -= m;  
                }  
                FileStream fstr = new FileStream(fileName, FileMode.OpenOrCreate, FileAccess.Write);  
                fstr.Write(mbyte, 0, startmbyte);  
                str.Close();  
                fstr.Close();  
                client.Dispose();  
            }  
            catch  
            {  
                // MessageBox.Show(exp.Message, "Error");   
            }  
        }  

    }

    class LrcShow
    {
        private static string musicPath;
        private static string lrcPath;
        private static string[] lrcString;
        private static string listItem;
        private static string  listItemUnAdd ="XX#ooX#X";
        private static bool isHasLrc=false;
        public static bool unClict=true;
        private static string[] clear;
        //main
        public static string get_lrc(string _musicPath,string _geciIst)
        {
            musicPath = _musicPath;
            getGeci_str();
            string listAdd=getList_add_geci(_geciIst);
            return listAdd;
           
        }

        public static void getGeci_str()
        {
            try
            {
            FileInfo fi = new FileInfo(musicPath);
            foreach (string gecifile in Directory.GetFiles(Application.StartupPath + "//Lrc//"))
            {
                FileInfo fi2 = new FileInfo(gecifile);
                lrcPath = fi.Name.Remove(fi.Name.LastIndexOf('.'));
                try
                {
                    if (fi2.Name.Substring(0, fi2.Name.Length - 4) == fi.Name.Substring(0, fi.Name.Length - 4))
                    {
                        lrcString = File.ReadAllLines(gecifile, Encoding.Default);
                        isHasLrc = true;
                        return;
                    }
                    lrcString = clear;
                    if (unClict)
                    {
                        Thread t2 = new Thread(new ThreadStart(fangfa));
                        t2.IsBackground = true;
                        t2.Start();
                        unClict = false;
                        isHasLrc = true;
                    }
                }
                catch
                {
                }
            }
            }
            catch
            {
            }
           
         
        }

        private static void fangfa()
        {
            LrcDownload.gecixia(lrcPath);
        }

        private static string  getList_add_geci(string currentPos)
        {
            try
            {
                for (int i = 0; i < lrcString.Length; i++)
                {
                    int l = lrcString[i].LastIndexOf("]");
                    if(l == 9)
                    {
                        if (getLengthWithFormat2(currentPos) == lrcString[i].Substring(l - 8, 5))
                        {
                            listItem = lrcString[i].Substring(l + 1, lrcString[i].Length - l - 1);
                            return listItem;
                        }
                    }
                    else
                        if (l == 19)
                        {
                            if (getLengthWithFormat2(currentPos) == lrcString[i].Substring(l - 8, 5) || getLengthWithFormat2(currentPos) == lrcString[i].Substring(l - 18, 5))
                            {
                                listItem = lrcString[i].Substring(l + 1, lrcString[i].Length - l - 1);
                                return listItem;
                            }
                          
                        }
                        else
                            if (l == 29)
                            {
                                if (getLengthWithFormat2(currentPos) == lrcString[i].Substring(l - 8, 5) || getLengthWithFormat2(currentPos) == lrcString[i].Substring(l - 18, 5) || getLengthWithFormat2(currentPos) == lrcString[i].Substring(l - 28, 5))
                                {
                                    listItem = lrcString[i].Substring(l + 1, lrcString[i].Length - l - 1);
                                    return listItem;
                                }
                              
                            }
                            else
                                if (l == 39)
                                {
                                    if (getLengthWithFormat2(currentPos) == lrcString[i].Substring(l - 8, 5) || getLengthWithFormat2(currentPos) == lrcString[i].Substring(l - 18, 5) || getLengthWithFormat2(currentPos) == lrcString[i].Substring(l - 28, 5) || getLengthWithFormat2(currentPos) == lrcString[i].Substring(l - 38, 5))
                                    {
                                        listItem = lrcString[i].Substring(l + 1, lrcString[i].Length - l - 1);
                                        return listItem;
                                    }
                                  
                                }
                                else
                                    if (l == 49)
                                    {
                                        if (getLengthWithFormat2(currentPos) == lrcString[i].Substring(l - 8, 5) || getLengthWithFormat2(currentPos) == lrcString[i].Substring(l - 18, 5) || getLengthWithFormat2(currentPos) == lrcString[i].Substring(l - 28, 5) || getLengthWithFormat2(currentPos) == lrcString[i].Substring(l - 38, 5) || getLengthWithFormat2(currentPos) == lrcString[i].Substring(l - 48, 5))
                                        {
                                            listItem = lrcString[i].Substring(l + 1, lrcString[i].Length - l - 1);
                                            return listItem;
                                        }
                                      
                                    }
                   
                }
                return listItemUnAdd;
            }
            catch
            {
                return listItemUnAdd;
            }
        }

        private static string getLengthWithFormat2(string mm)
        {
            string ccds = mm.Replace("00:", "");
            if (ccds.Length < 5)
            {
                ccds = "00:" + ccds;
            }
            return ccds;
        }
    }
}

