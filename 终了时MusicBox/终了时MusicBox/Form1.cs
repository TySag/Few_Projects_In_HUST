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
using Shell32;
using SpeechLib;
using System.Runtime.InteropServices;

namespace 终了时MusicBox
{
    public partial class Form1 : Form
    {
        bool move = false,bofang=false;
        public static bool gecix = false,meigeci=false;
        int xpos = 0, ypos = 0,zongshic,danshizhang,nlist=0,bflbx,songx,danfqs,fxlist,fxsong,bofangstyle=0;
        public static int hang=0,ji=1;
        public static string beijing;
        public static string ssname;
        public static int[] geci = new int[2000];
        public static string[] gecinr = new string[2000];
        public listsong[] listnamego = new listsong[100];
        int pre = 0, newm, fen = 0, shu = 0;
        bool sure = false;
        int timege = 500, ju = 3;
        int[] c = new int[1000];
        int[] k = new int[1000];
        PictureBox[] circle = new PictureBox[1000];
        Random a = new Random();
        string music,musicname,dqbf="当前播放: ",list,xinlie,zsc,dqs,xinsong,surl,nurl,jieshao,titlename,uurrll;
        desklrc dl = new desklrc();
        public Form1()
        {
            InitializeComponent(); 
            CheckForIllegalCrossThreadCalls = false; 
            StreamReader read = new StreamReader("confi\\desk\\xuan.txt");
            beijing = read.ReadLine();
            this.Cursor = new Cursor(Properties.Resources.sb.GetHicon());
            this.BackgroundImage = Image.FromFile(beijing);
            readfromtxt();
            label1.Text = dqbf + " 什么也木有播放";
            label2.Text = "00:00|00:00";
            label3.Hide();
            webBrowser1.Hide();
            read.Close();
            read.Dispose();
            readtolist();//
            chushilist();
            /*
            SpeechVoiceSpeakFlags SpFlags = SpeechVoiceSpeakFlags.SVSFlagsAsync;
            SpVoice Voice = new SpVoice();
            Voice.Speak("欢迎来到 终了时MusicBox ", SpFlags);
             */
            for (int i = 0; i < 1000; i++)
            {
                circle[i] = new PictureBox();
                circle[i].Size = new Size(60, 60);
                System.Drawing.Drawing2D.GraphicsPath g = new System.Drawing.Drawing2D.GraphicsPath();
                g.AddEllipse(new Rectangle(0, 0, 60, 60));
                circle[i].Region = new Region(g);
                g.Dispose();
                circle[i].Click += new EventHandler(this.makefen);
            }
//            Voice.WaitUntilDone(Timeout.Infinite);
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            SpeechVoiceSpeakFlags SpFlags = SpeechVoiceSpeakFlags.SVSFlagsAsync;
            SpVoice Voice = new SpVoice();
            Voice.Speak("欢迎来到 终了时MusicBox ", SpFlags);
        }
        private void readfromtxt()
        {
            StreamReader listread = new StreamReader("confi\\list\\list.txt");
            list = listread.ReadLine();
            while (true)
            {
                if (list == null)
                {
                    break;
                }
                this.listBox2.Items.Add(list);
                listnamego[nlist] = new listsong();
                listnamego[nlist].listname = list;
                listnamego[nlist].xian = true;
                nlist++;
                list = listread.ReadLine();
                listBox2.SelectedIndex = 0;
            }
            listread.Close();
            listread.Dispose();
        }
        private void readtolist() {//
            int i = 0;
            string songread;
            for (; i < nlist; i++) {
                StreamReader sr = new StreamReader("confi\\list\\"+listnamego[i].listname+".txt");
                songread = sr.ReadLine();
                while (true)
                {
                    if (songread == null)
                    {
                        break;
                    }
                    string []mystr=songread.Split('*');
                    listnamego[i].songname[listnamego[i].ns] = new songinf();
                    listnamego[i].songname[listnamego[i].ns].sname = mystr[0];//
                    //this.listBox1.Items.Add(mystr[0]);"● " + 
                    listnamego[i].songname[listnamego[i].ns].spath=mystr[1];//
                    listnamego[i].ns++;
                    songread = sr.ReadLine();
                }
                    sr.Close();
                    sr.Dispose();
               // listnamego[i].ns--;
            }
        }
        private void chushilist()
        {
            int i=0;
            bflbx = listBox2.SelectedIndex;
            for (; i < listnamego[bflbx].ns; i++)
            {
                this.listBox1.Items.Add(listnamego[bflbx].songname[i].sname);
            }
        }
        private void Form1_MouseMove(object sender, MouseEventArgs e)
        {
            if (move)
            {
                this.Left += MousePosition.X - xpos;
                this.Top += MousePosition.Y - ypos;
                xpos = MousePosition.X;
                ypos = MousePosition.Y; 
            }
        }

        private void Form1_MouseDown(object sender, MouseEventArgs e)
        {
            move = true;
            xpos = MousePosition.X;
            ypos = MousePosition.Y; 
        }

        private void Form1_MouseUp(object sender, MouseEventArgs e)
        {
            move = false;
        }

        private void button11_Click(object sender, EventArgs e)
        {
            Thread sthd = new Thread(new ThreadStart(this.skinhuan)); sthd.IsBackground = true;
            sthd.SetApartmentState( ApartmentState.STA);
            sthd.Start();
        }
        private void skinhuan() 
        { 
            skin s = new skin();
            s.ShowDialog();
            this.BackgroundImage = Image.FromFile(skin.path1);
            beijing = skin.path1;
        }
        private void button1_Click(object sender, EventArgs e)
        {
            DialogResult dr = MessageBox.Show("是否离开音乐盒？            ", "提示", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
            if (dr == DialogResult.Yes)
            {
                Application.Exit();
            }
        }

        private void button5_Click(object sender, EventArgs e)
        {
            //引发线程搜索
            if (textBox1.Text == "")
            {
                MessageBox.Show("请输入要查询的歌曲名");
            }
            else
            {
                ssname = textBox1.Text;
                textBox1.Text = "";
                Thread dthd = new Thread(new ThreadStart(this.sousong)); 
                dthd.IsBackground = true;
                dthd.SetApartmentState(ApartmentState.STA);
                dthd.Start();
            }
        }
        private void sousong() {
            //搜索歌曲
                askformusic a = new askformusic();
                a.ShowDialog();
        }
        private void button8_Click(object sender, EventArgs e)
        {
            //下载调用
            //默认路径根目录下song和lrc
            button6.ForeColor = Color.White;
            label3.Hide();
        }

        private void button7_Click(object sender, EventArgs e)
        {
            //显示酷我的主界面或百度音乐的主界面
            button6.ForeColor = Color.White;
            Random wy = new Random();//string uurrll="http://music.baidu.com/";
            int y=Convert.ToInt32(wy.Next(0, 2));
        //    y = 1;
            if (y == 0)
            {
                uurrll = "http://www.kuwo.cn/";
            }
            else if (y == 1)
                uurrll = "http://music.baidu.com/";
            else
                uurrll = "http://www.kugou.com/";
            Uri r = new Uri(uurrll);
            label3.Hide();
            this.webBrowser1.Show();
            this.webBrowser1.Url = r;
        }

        private void button6_Click(object sender, EventArgs e)
        {
            //调用label或richbox使得歌词显示，要求界面透明
            //歌词居中，使所读的行变色
            webBrowser1.Hide();
            button6.ForeColor = Color.Yellow;//读取歌词
            label3.Show();
          //  Thread readgc = new Thread(new ThreadStart(this.gecishow)); readgc.IsBackground = true;
            //readgc.SetApartmentState(ApartmentState.STA);
           // readgc.Start();
        }
        private void gecishow() {
        //    this.panel1.Visible = false;
            label3.Text = "";
            Array.Clear(gecinr, 0, gecinr.Length);
            Array.Clear(geci, 0, geci.Length);
            string str, str1;
            int a, b;
            a = listBox2.SelectedIndex;//
            if (listnamego[a].xian == false)
            {
                a++;
            }
            b = this.listBox1.SelectedIndex;//
            str = listnamego[a].songname[b].spath;
            str1 = Path.ChangeExtension(str,".lrc");
            if (File.Exists(str1))
            {
                meigeci = false;
                int i = 0;
                string wg;
                StreamReader gc = new StreamReader(str1,  System.Text.Encoding.Default,false);
                wg = gc.ReadLine();
                while (wg != null)
                {
                    string[] mystr = wg.Split(']');
                    if (mystr.Length==2&&mystr[1]!="")
                    {
                        if (i == 0) {
                            label3.Text = jieshao+'\n'+'\n'+'\n';
                            titlename = jieshao;
                            jieshao = string.Empty;
                        }
                        string[] timefen = mystr[0].Split('[');
                        string[] timeji = timefen[1].Split(':');
                        string[] timemiao = timeji[1].Split('.');
                        geci[i] = 60 * Convert.ToInt32(timeji[0]) + Convert.ToInt32(timemiao[0]);
                        gecinr[i++] = mystr[1];
                    }
                    else if(mystr.Length==1){
                        if (mystr[0].Trim().Equals(string.Empty))
                        {
                            wg = gc.ReadLine();
                            continue;
                        }
                        else
                        {
                            string[] fen = mystr[0].Split(':');
                            jieshao = jieshao + fen[1] + "|";
                        }
                    }
                    else if (mystr.Length == 2 && mystr[1] == "") {
                        wg = gc.ReadLine();
                        continue;
                    }
                    label3.Text = label3.Text + mystr[1]+'\n';
                    wg = gc.ReadLine();
                }
                gc.Close();
                gc.Dispose();
            }
            else {
                meigeci = true;
                this.label3.Text = "~~~~没有找到歌词~~~";
            }
        }
        private void button10_Click(object sender, EventArgs e)
        {
            //版本信息和更新信息
            Thread nmes = new Thread(new ThreadStart(this.newmessage)); 
            nmes.IsBackground = true;
            nmes.SetApartmentState(ApartmentState.STA);
            nmes.Start();
        }
        private void newmessage() {
            update u = new update();
            u.ShowDialog();
        }
        private void button4_Click(object sender, EventArgs e)
        {
            //调用小的box，只要有播放功能就行
        }

        private void button15_Click(object sender, EventArgs e)
        {
            //添加功能
            OpenFileDialog smusic = new OpenFileDialog();
            smusic.Filter = "音乐文件(*.wav;*.mp3;*.snd;*.au;*.midi;*.mid;*.wma)|*.wav;*.mp3;*.snd;*.au;*.midi;*.mid;*.wma";
            smusic.FilterIndex = 1;
            smusic.RestoreDirectory = true;
            smusic.Title = "添加歌曲到当前列表";
            if (smusic.ShowDialog() == DialogResult.OK)
            {
                bflbx = listBox2.SelectedIndex;//
                songx = this.listBox1.Items.Count;//
                music = smusic.FileName;
                listnamego[bflbx].songname[songx] = new songinf();//
                listnamego[bflbx].songname[songx].spath = music;//
                listnamego[bflbx].songname[songx].sname = Path.GetFileNameWithoutExtension(music);
                listnamego[bflbx].ns++;
                this.listBox1.Items.Add(listnamego[bflbx].songname[songx].sname);//向列表框中添加播放列表this.listBox1.Items.AddRange(smusic.FileNames);
                this.listBox1.SelectedIndex = this.listBox1.Items.Count - 1;
                axWindowsMediaPlayer1.URL = music;
                button18.BackgroundImage = Properties.Resources.play;
                bofang = true;
                xinsong = listnamego[bflbx].songname[songx].sname + "*" + listnamego[bflbx].songname[songx].spath;
                StreamWriter lisongw = File.AppendText("confi\\list\\" + listnamego[bflbx].listname + ".txt");
                lisongw.WriteLine(xinsong);
                lisongw.Close();
                lisongw.Dispose();
            }
            else {
                return;
            }
            acquiretitle();
                // bpic = bkpic.FileName;
                // path1 = "confi\\desk\\" + bkpic.SafeFileName;
                // tem1 = Path.GetFileNameWithoutExtension(path1);
                //  tem2= Path.GetExtension(path1);
            //controls.currentPositionString
        }

        private void button16_Click(object sender, EventArgs e)
        {
            //删除功能
            bflbx = listBox2.SelectedIndex;
            int y = listBox1.SelectedIndex,i;
            listBox1.Items.RemoveAt(y);
            for (i = y; i < listnamego[bflbx].ns - 1; i++) {
                listnamego[bflbx].songname[i].sname = listnamego[bflbx].songname[i + 1].sname;
                listnamego[bflbx].songname[i].spath = listnamego[bflbx].songname[i + 1].spath;
            }
            listnamego[bflbx].ns--;
        }

        private void button17_Click(object sender, EventArgs e)
        {
            //播放模式
            if (bofangstyle == 0) {
                bofangstyle = 1;
                button17.BackgroundImage = Properties.Resources.QQ截图20130619180936;
            }
            else if (bofangstyle == 1) {
                bofangstyle = 2;
                button17.BackgroundImage = Properties.Resources.QQ截图20130619180921;
            }
            else {
                bofangstyle = 0;
                button17.BackgroundImage = Properties.Resources.QQ截图20130611232233;
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            //最小化，在后台运行
            this.WindowState = FormWindowState.Minimized;
        }
        private void sizetomin() {
                this.ShowInTaskbar = false;
                this.notifyIcon1.Visible = true;
                this.Hide();
        }
        private void button12_Click(object sender, EventArgs e)
        {
            //保存所在列表list1
            int i;
            string baocun;
            bflbx = listBox2.SelectedIndex;
            File.Delete("confi\\list\\" + listnamego[bflbx].listname + ".txt");
            //  File.Create("confi\\list\\" + listnamego[bflbx].listname + ".txt").Close();
            FileStream fs = new FileStream("confi\\list\\" + listnamego[bflbx].listname + ".txt",FileMode.CreateNew);
            StreamWriter sw = new StreamWriter(fs);
            for (i = 0; i < listnamego[bflbx].ns; i++)
            {
                baocun = listnamego[bflbx].songname[i].sname + "*" + listnamego[bflbx].songname[i].spath;
                sw.WriteLine(baocun);
            }
            sw.Close();
            sw.Dispose();
            MessageBox.Show("  该列表已保存完毕！！   ");
        }

        private void button13_Click(object sender, EventArgs e)
        {
            //删除所在列表list1，转到默认列表
            DialogResult dr = MessageBox.Show("是否删去选中的列表？            ", "提示", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
            if (dr == DialogResult.Yes)
            {
                int i = 0,n=listBox2.Items.Count;
                bflbx = listBox2.SelectedIndex;
                listBox2.Items.RemoveAt(bflbx);
                listBox1.Items.Clear();
                listnamego[bflbx].xian = false;

                File.Delete("confi\\list\\" + listnamego[bflbx].listname + ".txt");
                File.Delete("confi\\list\\list.txt");
                FileStream fs = new FileStream("confi\\list\\list.txt", FileMode.CreateNew);
                StreamWriter sw = new StreamWriter(fs);
                for (; i < n; i++) {
                    if (i != bflbx) {
                        sw.WriteLine(listnamego[i].listname);
                    }
                }
                sw.Close();
                sw.Dispose();
              //  readfromtxt();
            }
        }

        private void button14_Click(object sender, EventArgs e)
        {
            //新建一个list1
            int i = 0;
            for (i = this.listBox1.Items.Count - 1; i >= 0; i--)
            {
                listBox1.SelectedIndex = i;
                this.listBox1.Items.Remove(this.listBox1.SelectedItem);
            }
            xinlie = "新建列表" + (this.listBox2.Items.Count).ToString();
            this.listBox2.Items.Add(xinlie);
        //  FileStream fs = new FileStream("confi\\list\\list.txt",FileMode.Append);new StreamWriter
            StreamWriter listw = File.AppendText("confi\\list\\list.txt");
            listw.WriteLine(xinlie);
            listBox2.SelectedIndex = this.listBox2.Items.Count - 1;
            bflbx = listBox2.SelectedIndex;
            listnamego[bflbx] = new listsong();
            listnamego[bflbx].listname = xinlie;
            nlist++;
            File.Create("confi\\list\\" + listnamego[bflbx].listname + ".txt").Close();
            listw.Close();
            listw.Dispose();
        }

        private void button9_Click(object sender, EventArgs e)
        {
            //列表信息和使用者信息
            button6.ForeColor = Color.White;
            label3.Hide();
        }

        private void notifyIcon1_MouseDoubleClick(object sender, MouseEventArgs e)
        {
            this.Visible = true;
            this.Show();
            this.ShowInTaskbar = true;
            this.WindowState = FormWindowState.Normal;
            this.notifyIcon1.Visible = false;
        }

        private void Form1_SizeChanged(object sender, EventArgs e)
        {
            if (this.WindowState == System.Windows.Forms.FormWindowState.Minimized)
            {
                this.sizetomin();
            }
        }

        private void 播放ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            DialogResult dr = MessageBox.Show("是否离开音乐盒？            ", "提示", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
            if (dr == DialogResult.Yes)
            {
                Application.Exit();
            }
        }

        private void 暂停ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            //停止当前活动
        }

        private void 退出ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            DialogResult dr = MessageBox.Show("是否离开音乐盒？            ", "提示", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
            if (dr == DialogResult.Yes)
            {
                Application.Exit();
            }
        }

        private void 显示ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.Visible = true;
            this.Show();
            this.ShowInTaskbar = true;
            this.WindowState = FormWindowState.Normal;
            this.notifyIcon1.Visible = false;
        }

        private void button22_Click(object sender, EventArgs e)
        {
            Thread zmgc = new Thread(new ThreadStart(this.lrcbegin)); zmgc.IsBackground = true;
            zmgc.SetApartmentState(ApartmentState.STA);
            if(gecix==false){
                button22.ForeColor = Color.Yellow;
                gecix = true;
                zmgc.Start();
            }
            else{
                button22.ForeColor = Color.Red;
                gecix = false;
                dl.Close();
            }
        }
        private void lrcbegin() {
            if (gecix == false)
            {
                dl.Close();
            }
            else
            { 
                dl.ShowDialog();
            }
        }
        private void button18_Click(object sender, EventArgs e)
        {
            if (bofang == false) 
            {
                button18.BackgroundImage = Properties.Resources.play;
                axWindowsMediaPlayer1.Ctlcontrols.play();
                timer1.Enabled = true;
                ji = 1;
                bofang = true;
            }
            else
            {
                button18.BackgroundImage = Properties.Resources.pause;
                axWindowsMediaPlayer1.Ctlcontrols.pause();
                timer1.Enabled = false;
                ji = 0;
                bofang = false;
            }
        }

        private void button19_Click(object sender, EventArgs e)
        {
           // axWindowsMediaPlayer1.Ctlcontrols.previous();
            try
            {
                this.listBox1.SelectedIndex -= 1;
                bflbx = listBox2.SelectedIndex;//
                if (listnamego[bflbx].xian == false)
                {
                    bflbx++;
                }
                danfqs = this.listBox1.SelectedIndex;//
                this.axWindowsMediaPlayer1.URL = listnamego[bflbx].songname[danfqs].spath; //this.listBox1.SelectedItem.ToString();
            }
            catch
            {
                this.listBox1.SelectedIndex = this.listBox1.Items.Count - 1;
                bflbx = listBox2.SelectedIndex;//
                if (listnamego[bflbx].xian == false)
                {
                    bflbx++;
                }
                danfqs = this.listBox1.SelectedIndex;//
                this.axWindowsMediaPlayer1.URL = listnamego[bflbx].songname[danfqs].spath; //this.listBox1.SelectedItem.ToString();
            }
            if (bofang == false)
            {
                button18.BackgroundImage = Properties.Resources.play;
                bofang = true;
            }
            music = listnamego[bflbx].songname[danfqs].spath;//this.listBox1.SelectedItem.ToString()
            acquiretitle();
        }

        private void button20_Click(object sender, EventArgs e)
        {
            button18.BackgroundImage = Properties.Resources.pause;
            axWindowsMediaPlayer1.Ctlcontrols.stop();
            timer1.Enabled = false;
            ji = 0;
            danshizhang = 0;
            label1.Text = dqbf + " 什么也木有播放";
            label2.Text = "00:00|00:00";
            bofang = false;
        }

        private void button21_Click(object sender, EventArgs e)
        {
            // axWindowsMediaPlayer1.Ctlcontrols.next();
            try
            {
                this.listBox1.SelectedIndex += 1;
                bflbx = listBox2.SelectedIndex;//
                if (listnamego[bflbx].xian == false)
                {
                    bflbx++;
                }
                danfqs = this.listBox1.SelectedIndex;//
                this.axWindowsMediaPlayer1.URL = listnamego[bflbx].songname[danfqs].spath;
            }
            catch
            {
                this.listBox1.SelectedIndex = 0;
                bflbx = listBox2.SelectedIndex;//
                if (listnamego[bflbx].xian == false)
                {
                    bflbx++;
                }
                danfqs = this.listBox1.SelectedIndex;//
                this.axWindowsMediaPlayer1.URL = listnamego[bflbx].songname[danfqs].spath;
            }
            if (bofang == false)
            {
                button18.BackgroundImage = Properties.Resources.play;
                bofang = true;
            }
            music = listnamego[bflbx].songname[danfqs].spath;//this.listBox1.SelectedItem.ToString()
            acquiretitle();
        }
        private void acquiretitle()
        {
            zongshic = (int)axWindowsMediaPlayer1.newMedia(music).duration;
            musicname = Path.GetFileNameWithoutExtension(music);;
            if ((zongshic / 60) < 10)
            {
                if ((zongshic % 60) < 10)
                {
                    zsc = "0" + (zongshic / 60).ToString() + ":0" + (zongshic % 60).ToString();
                }
                else
                {
                    zsc = "0" + (zongshic / 60).ToString() + ":" + (zongshic % 60).ToString();
                }
            }
            else
            {
                if ((zongshic % 60) < 10)
                {
                    zsc = (zongshic / 60).ToString() + ":0" + (zongshic % 60).ToString();
                }
                else
                {
                    zsc = (zongshic / 60).ToString() + ":" + (zongshic % 60).ToString();
                }
            }
            label1.Text = dqbf + " " + musicname;
            label2.Text = "00:00" + "|" + zsc;//时刻记录时间长度
            danshizhang = 0;
            hang = 0;
       //     Thread stime= new Thread(new ThreadStart(this.begintime));
       //     stime.SetApartmentState(ApartmentState.STA);
            //    stime.Start();
            Thread readgc = new Thread(new ThreadStart(this.gecishow)); readgc.IsBackground = true;
            readgc.SetApartmentState(ApartmentState.STA);
            readgc.Start();
            begintime();
        }
        private void begintime() 
        {
            timer1.Enabled = true;
            ji = 1;
        }
        private void listBox1_MouseDoubleClick(object sender, MouseEventArgs e)
        {
            if (this.listBox1.Items.Count > 0)
            {
                if (bofang == false)
                {
                    button18.BackgroundImage = Properties.Resources.play;
                    bofang = true;
                }
                bflbx = listBox2.SelectedIndex;//
                if (listnamego[bflbx].xian == false) {
                    bflbx++;
                }
                danfqs= this.listBox1.SelectedIndex;//
                this.axWindowsMediaPlayer1.URL = listnamego[bflbx].songname[danfqs].spath;//this.listBox1.SelectedItem.ToString()
                music = listnamego[bflbx].songname[danfqs].spath;//this.listBox1.SelectedItem.ToString()
                acquiretitle();
            }
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            danshizhang++;
            if (danshizhang < zongshic)
            {
                if ((danshizhang / 60) < 10)
                {
                    if ((danshizhang % 60) < 10)
                    {
                        dqs = "0" + (danshizhang / 60).ToString() + ":0" + (danshizhang % 60).ToString();
                    }
                    else
                    {
                        dqs = "0" + (danshizhang / 60).ToString() + ":" + (danshizhang % 60).ToString();
                    }
                }
                else
                {
                    if ((danshizhang % 60) < 10)
                    {
                        dqs = (danshizhang / 60).ToString() + ":0" + (danshizhang % 60).ToString();
                    }
                    else
                    {
                        dqs = (danshizhang / 60).ToString() + ":" + (danshizhang % 60).ToString();
                    }
                }
                label2.Text = dqs+ "|" + zsc;//时刻记录时间长度
            }
            else
            {
                timer1.Enabled = false;
                ji = 0;
                try
                {
                    if (bofangstyle == 1)
                    {
                        Random random = new Random();
                        int x = Convert.ToInt32(random.Next(0, (this.listBox1.Items.Count - 1)));
                        this.listBox1.SelectedIndex = x;
                    }
                    else if(bofangstyle==0)
                    {
                        this.listBox1.SelectedIndex += 1;
                    }
                    bflbx = listBox2.SelectedIndex;//
                    if (listnamego[bflbx].xian == false) {
                        bflbx++;
                    }
                    danfqs = this.listBox1.SelectedIndex;//
                    this.axWindowsMediaPlayer1.URL = listnamego[bflbx].songname[danfqs].spath;
                }
                catch
                {
                    this.listBox1.SelectedIndex = 0;
                    bflbx = listBox2.SelectedIndex;//
                    danfqs = this.listBox1.SelectedIndex;//
                    this.axWindowsMediaPlayer1.URL = listnamego[bflbx].songname[danfqs].spath;
                }
                music = listnamego[bflbx].songname[danfqs].spath;//this.listBox1.SelectedItem.ToString()
                acquiretitle();
            }
            if (danshizhang >= geci[hang]&&meigeci==false) { 
                label3.Text=titlename+"\n\n";
                int chang=gecinr.Length;
                for(int i=hang;i<chang;i++){
                   label3.Text=label3.Text+"\n"+gecinr[i];
               }
                hang++;
            }
        }

        private void listBox2_DoubleClick(object sender, EventArgs e)
        {
            //清空当前list1；
            int i = 0;
            for(i=this.listBox1.Items.Count-1;i>=0;i--)
            {
                listBox1.SelectedIndex = i;
                this.listBox1.Items.Remove(this.listBox1.SelectedItem);
            }
            bflbx = listBox2.SelectedIndex;
            if (listnamego[bflbx].xian == false) {
                bflbx++;
            }
            for (i=0;i < listnamego[bflbx].ns ; i++)
            {
                this.listBox1.Items.Add(listnamego[bflbx].songname[i].sname);
            }
        }

       
        private void 分享至QQToolStripMenuItem_Click(object sender, EventArgs e)
        {
            fxlist = listBox2.SelectedIndex;
            fxsong = listBox1.SelectedIndex;
            surl = "http" + ":" + "//sns.qzone.qq.com/cgi-bin/qzshare/cgi_qzshare_onekey?url= http://yunpan.cn/QezzmhgqDeQqq ";// http://user.qzone.qq.com/2368962312/infocenter  //
            nurl = surl + "&title=来自 终了时MusicBox: " +"&desc=我喜欢的" +listnamego[fxlist].songname[fxsong].sname + " 希望你能喜欢~~~";
            try
            {
                System.Diagnostics.Process.Start(nurl);
            }
            catch
            {
                Console.WriteLine("Exception when creating Internet  Explorer object {0}",e);
                return;
            }
        }
        //<script type="text/javascript">
//(function(){
//var p = {
//url:location.href,showcount:'1',/*是否显示分享总数,显示：'1'，不显示：'0' */desc:'',/*默认分享理由(可选)*/
//summary:'',/*分享摘要(可选)*/title:'',/*分享标题(可选)*/site:'',/*分享来源 如：腾讯网(可选)*/pics:'', /*分享图片的路径(可选)*/
//style:'203',width:98,height:22};var s = [];for(var i in p){s.push(i + '=' + encodeURIComponent(p[i]||''));}
//document.write(['<a version="1.0" class="qzOpenerDiv" href="http://sns.qzone.qq.com/cgi-bin/qzshare/cgi_qzshare_onekey?',s.join('&'),'" target="_blank">分享</a>'].join(''));
//})();</script><script src="http://qzonestyle.gtimg.cn/qzone/app/qzlike/qzopensl.js#jsdate=20111201" charset="utf-8"></script>
        private void 分享至微博ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            fxlist=listBox2.SelectedIndex;
            fxsong=listBox1.SelectedIndex;
            surl= "http"+":"+"//share.v.t.qq.com/index.php?c=share&a=index&title=";
            nurl = surl + "来自 终了时MusicBox:  我喜欢的" + listnamego[fxlist].songname[fxsong].sname + " 希望你能喜欢~~~" + "&url=null";
            try
            {
                // 调用默认浏览器打开网址.
                System.Diagnostics.Process.Start(nurl);
            }
            catch
            {
                Console.WriteLine("Exception when creating Internet  Explorer object {0}", e);
                return;
            }
        }

        private void 分享给QQToolStripMenuItem_Click(object sender, EventArgs e)
        {
            fxlist = listBox2.SelectedIndex;
            fxsong = listBox1.SelectedIndex;
            surl = "http" + ":" + "//connect.qq.com/widget/shareqq/index.html?title=";
            nurl = surl + "来自 终了时MusicBox:  我喜欢的" + listnamego[fxlist].songname[fxsong].sname + " 希望你能喜欢~~~" + "&url=null";
            try
            {
                System.Diagnostics.Process.Start(nurl);
            }
            catch
            {
                Console.WriteLine("Exception when creating Internet  Explorer object {0}", e);
                return;
            }
        }

        private void 分享到新浪微博ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            fxlist = listBox2.SelectedIndex;
            fxsong = listBox1.SelectedIndex;
            surl = "http" + ":" + "//v.t.sina.com.cn/share/share.php?title=";//hits.sinajs.cn/A1/weiboshare.html?
            nurl = surl + "来自 终了时MusicBox:  我喜欢的" + listnamego[fxlist].songname[fxsong].sname + " 希望你能喜欢~~~" + "";
            try
            {
                System.Diagnostics.Process.Start(nurl);
            }
            catch
            {
                Console.WriteLine("Exception when creating Internet  Explorer object {0}", e);
                return;
            }
        }

        private void 暂停ToolStripMenuItem1_Click(object sender, EventArgs e)
        {
                button18.BackgroundImage = Properties.Resources.pause;
                axWindowsMediaPlayer1.Ctlcontrols.pause();
                timer1.Enabled = false;
                ji = 0;
                bofang = false;
        }

        private void 播放ToolStripMenuItem1_Click(object sender, EventArgs e)
        {
                button18.BackgroundImage = Properties.Resources.play;
                axWindowsMediaPlayer1.Ctlcontrols.play();
                timer1.Enabled = true;
                ji = 1;
                bofang = true;
        }

        private void 暂停ToolStripMenuItem_Click_1(object sender, EventArgs e)
        {
                button18.BackgroundImage = Properties.Resources.pause;
                axWindowsMediaPlayer1.Ctlcontrols.pause();
                timer1.Enabled = false;
                ji = 0;
                bofang = false;
        }

        private void 播放ToolStripMenuItem_Click_1(object sender, EventArgs e)
        {
                button18.BackgroundImage = Properties.Resources.play;
                axWindowsMediaPlayer1.Ctlcontrols.play();
                timer1.Enabled = true;
                ji = 1;
                bofang = true;
        }

        private void 循环播放ToolStripMenuItem_Click(object sender, EventArgs e)
        {
                bofangstyle = 0;
                button17.BackgroundImage = Properties.Resources.QQ截图20130611232233;
        }

        private void 单曲重复ToolStripMenuItem_Click(object sender, EventArgs e)
        {
                bofangstyle = 2;
                button17.BackgroundImage = Properties.Resources.QQ截图20130619180921;

        }

        private void 随机播放ToolStripMenuItem_Click(object sender, EventArgs e)
        {
                bofangstyle = 1;
                button17.BackgroundImage = Properties.Resources.QQ截图20130619180936;
        }

        private void 移出列表ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            bflbx = listBox2.SelectedIndex;
            int y = listBox1.SelectedIndex, i;
            listBox1.Items.RemoveAt(y);
            for (i = y; i < listnamego[bflbx].ns - 1; i++)
            {
                listnamego[bflbx].songname[i].sname = listnamego[bflbx].songname[i + 1].sname;
                listnamego[bflbx].songname[i].spath = listnamego[bflbx].songname[i + 1].spath;
            }
            listnamego[bflbx].ns--;
        }

        private void toolStripMenuItem2_Click(object sender, EventArgs e)
        {
          //  this.listBox1.ForeColor = ;
        }

        private void toolStripMenuItem4_Click(object sender, EventArgs e)
        {
            //  this.listBox1.ForeColor = ;
        }

        private void toolStripMenuItem5_Click(object sender, EventArgs e)
        {

            //  this.listBox1.ForeColor = ;
        }

        private void toolStripMenuItem6_Click(object sender, EventArgs e)
        {


            //  this.listBox1.ForeColor = ;
        }

        private void toolStripMenuItem3_Click(object sender, EventArgs e)
        {

            //  this.listBox1.ForeColor = ;
        }

        private void webBrowser1_FileDownload(object sender, EventArgs e)
        {
            //
        }

        private void 打开文件位置ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            string open;
            int w1,w2;
            open = this.axWindowsMediaPlayer1.URL;
            if (listBox2.SelectedIndex != -1) { 
                w1 = listBox2.SelectedIndex;
                w2 = listBox1.SelectedIndex;
                open = listnamego[w1].songname[w2].spath;
            }
            string[] wen = open.Split('\\');
            open=string.Empty;
            for (int i = 0; i < wen.Length-2;i++ ){
                open=open+wen[i]+"\\";
            }
            open=open+wen[wen.Length-2];
            System.Diagnostics.Process.Start("explorer.exe", open); 
        }

        private void button23_Click(object sender, EventArgs e)
        {
            button23.ForeColor = Color.Red;
       /*     Thread p = new Thread(new ThreadStart(this.playwithmusic)); p.IsBackground = true;
            p.SetApartmentState(ApartmentState.STA);
            p.Start();*/
            playwithmusic();
        }
        private void playwithmusic()
        {
            pre = 0;
            sure = false;
            panel1.Controls.Clear();
            timer2.Interval = timege;
            timer2.Enabled = true;
        }
        private void makefen(object sender, EventArgs e)
        {

        }
        private void timer2_Tick(object sender, EventArgs e)
        {
            newm = axWindowsMediaPlayer1.settings.volume;
            if (newm > pre)
            {
                shu = 0;
                makecircle();
            }
            pre = newm;
        }
        private void makecircle()
        {
            circle[shu].BackColor = Color.Red;
            c[shu]=a.Next(0,600);
            k[shu]=a.Next(0,400);
            circle[shu].Location = new Point(c[shu],k[shu]);
            panel1.Controls.Add(circle[shu]);
            shu++;
        }

    }
}
