using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Runtime.InteropServices;
using System.IO;
using MediaControlLibrary;

namespace MusicPlayer
{
    public partial class MainForm : Form
    {
        //public const Int32 AW_HOR_POSITIVE = 0x00000001;
        //public const Int32 AW_HOR_NEGATIVE = 0x00000002;
        //public const Int32 AW_VER_POSITIVE = 0x00000004;
        //public const Int32 AW_VER_NEGATIVE = 0x00000008;
        public const Int32 AW_CENTER = 0x00000010;
        //public const Int32 AW_HIDE = 0x00010000;
        //public const Int32 AW_ACTIVATE = 0x00020000;
        //public const Int32 AW_SLIDE = 0x00040000;
        //public const Int32 AW_BLEND = 0x00080000;

        public MainForm()
        {
            InitializeComponent();

            //设置最大尺寸，防止全屏时遮挡任务栏
            this.MaximumSize = Screen.PrimaryScreen.WorkingArea.Size;

            //启动动画
            AnimateWindow(this.Handle, 100, 0x00000010);//开始窗体动画，中心展开

            //歌词窗口
            //lyricShow1.InitAndShowDesktopLyric();

            for (int i = 0; i < 1; i++)
            {
                MediaList list = new MediaList("默认列表");
                for (int j = 0; j < 10; j++)
                {
                    MediaItem item = new MediaItem("歌曲" + j, "00:00");
                    item.SecondContent = "111223";
                    list.SubItems.Add(item);
                }
                mediaContainer1.Lists.Add(list);
                MediaList list1 = new MediaList("新建列表");
                mediaContainer1.Lists.Add(list1);
            }

        }

        /// <summary>
        /// 退出时动画效果
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void MainForm_FormClosed(object sender, FormClosedEventArgs e)
        {
            if (this.WindowState != FormWindowState.Minimized)
            {
                while (this.Height > 10)
                {
                    this.Location = new Point(this.Location.X, this.Location.Y + 15);
                    this.Height -= 30;
                    this.Opacity -= 0.01;
                }
            }
            Application.Exit();
        }


        #region 播放控制与信息显示相关变量
        MyMedia mySong = new MyMedia();
        bool IsMute = false;
        bool IsStop = false;

        #endregion

        #region API和常量
        [DllImport("user32.dll")]
        private static extern bool AnimateWindow(IntPtr hwnd, int dwTime, int dwFlags);

        [DllImport("user32.dll")]
        public static extern bool ReleaseCapture();

        [DllImport("user32.dll")]
        private static extern bool SendMessage(IntPtr hwnd, int wMsg, int wParam, int lParam);
        
        private const int WM_SYSCOMMAND = 0x0112;
        private const int SC_MOVE = 0xF010;
        private const int HTCAPTION = 0x0002;

        private const int WM_NCHITTEST = 0x84;
        private const int HTCLIENT = 0x1;
        private const int WM_NCLBUTTONDBLCLK = 0xA3;//鼠标双击标题栏消息 

        //改变窗体大小
        public const int WMSZ_LEFT = 0xF001;
        public const int WMSZ_RIGHT = 0xF002;
        public const int WMSZ_TOP = 0xF003;
        public const int WMSZ_TOPLEFT = 0xF004;
        public const int WMSZ_TOPRIGHT = 0xF005;
        public const int WMSZ_BOTTOM = 0xF006;
        public const int WMSZ_BOTTOMLEFT = 0xF007;
        public const int WMSZ_BOTTOMRIGHT = 0xF008;

        #endregion

        #region 无边框窗口拖动及大小状态切换

        protected override CreateParams CreateParams
        {
            get
            {
                const int WS_MINIMIZEBOX = 0x00020000;  // Winuser.h中定义
                CreateParams cp = base.CreateParams;
                cp.Style = cp.Style | WS_MINIMIZEBOX;   // 允许最小化操作
                return cp;
            }
        }

        private void tpnlMain_MouseDown(object sender, MouseEventArgs e)
        {
            //如果是顶部或底部的空栏
            if ((e.Y > 0 && e.Y < 30) || (e.Y > this.Height - 40 && e.Y < this.Height))
            {
                //按下的是鼠标左键，则拖动窗口
                if (e.Button == MouseButtons.Left)
                {
                    ReleaseCapture();
                    SendMessage(this.Handle, WM_SYSCOMMAND, SC_MOVE + HTCAPTION, 0);//*********************调用移动无窗体控件函数           
                }

                //双击顶部标题栏切换窗口状态

                if ((e.Y > 0 && e.Y < 30) && e.Button == MouseButtons.Left && e.Clicks == 2)
                {
                    if (this.WindowState == FormWindowState.Normal)
                    {
                        SendMessage(this.Handle, 274, 61488, 0);
                        return;
                    }
                    if (this.WindowState == FormWindowState.Maximized)
                    {
                        SendMessage(this.Handle, 274, 61728, 0);
                        return;
                    }
                }
            }

            //拉伸改变大小
            if (e.Y>0&&e.Y<3)
            {
                SendMessage(this.Handle,WM_SYSCOMMAND, WMSZ_TOP,0);
            }
        }

        private void btnCloseBox_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void btnMaximizeBox_Click(object sender, EventArgs e)
        {
            //if (Properties.Settings.Default.RememberMaximizeFunction == 0)
            //{
            //    Point P = PointToScreen(new Point(btnMaximizeBox.Left, btnMaximizeBox.Bottom));
            //    cmenuMaxMode.Show(P);
            //}


            if (this.WindowState == FormWindowState.Normal)
            {
                this.WindowState = FormWindowState.Maximized;
            }
            else
            {
                this.WindowState = FormWindowState.Normal;
            }
        }

        private void btnMinimizeBox_Click(object sender, EventArgs e)
        {
            this.WindowState = FormWindowState.Minimized;
        }

        private void 音乐魔方模式ToolStripMenuItem_Click(object sender, EventArgs e)
        {

        }

        private void 最大化ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (this.WindowState == FormWindowState.Normal)
            {
                this.WindowState = FormWindowState.Maximized;
            }
            else
            {
                this.WindowState = FormWindowState.Normal;
            }
        }

        private void 记住我的选择ToolStripMenuItem_Click(object sender, EventArgs e)
        {

        }

        #endregion

        private void MainForm_Load(object sender, EventArgs e)
        {
            tbarVolume.Value = Properties.Settings.Default.Volume;
           
            webBrowser1.Url = new Uri( "http://www.kugou.com/fm2/");
        }

        #region 播放控制和状态信息显示

        /// <summary>
        /// 播放、暂停
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void btnPlayPause_Click(object sender, EventArgs e)
        {
            if (mySong.CurrentState != State.Playing)
            {
                MyTime.Start();
                mySong.Play();
            }
            else
            {
                MyTime.Stop();
                mySong.Puase();
            }
        }

        /// <summary>
        /// 上一首
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void btnPreSong_Click(object sender, EventArgs e)
        {

        }

        private void btnNextSong_Click(object sender, EventArgs e)
        {
            //OpenFileDialog ofd = new OpenFileDialog();
            //ofd.Filter = "歌词文件(*.lrc)|*.lrc";
            //if (ofd.ShowDialog() == DialogResult.OK)
            //{
            //    LyricShow.Lyric l = new LyricShow.Lyric(ofd.FileName);
            //    lyricShow1.SetLyric(l);
            //}
        }

        /// <summary>
        /// 显示时间提示
        /// </summary>
        /// <param name="durTime">已播放时间</param>
        /// <param name="totalTime">歌曲总时间</param>
        private void DisplayTime(long durTime,long totalTime)
        {
            lblPastTime.Text = string.Format("{0:D2}:{1:D2}", durTime / 60, durTime % 60);
            lblTotalTime.Text = string.Format("{0:D2}:{1:D2}", totalTime / 60, totalTime % 60);
        }

        /// <summary>
        /// 从完整路径中分离出歌曲名
        /// </summary>
        /// <param name="path">完整路径</param>
        /// <returns>歌名</returns>
        private string GetSongName(string path)
        {
            int index1=path.LastIndexOf(@"\");
            int index2 = path.LastIndexOf(@".");
            string songName = path.Substring(index1 + 1,index2-index1);
            return songName;
        }

        #endregion

        // 动态显示时间和时间条
        private void MyTime_Tick(object sender, EventArgs e)
        {
            //lyricShow1.CurrentProgress = mySong.CurrentPosition;
            //lyricShow1.RefreshDesktopLyric();

            IsStop = false;
            if (mySong.CurrentState == State.Playing)
            {
                //tbarTime.Value = mySong.CurrentPosition;
            }
            else if (mySong.CurrentState == State.Puased)
            {
                MyTime.Stop();
            }
            //DisplayTime(tbarTime.Value, mySong.TotalSeconds);
        }


        // 左上角标题图标点击,弹出菜单
        private void btnTitleAndIcon_Click(object sender, EventArgs e)
        {
            Point P = PointToScreen(new Point(btnTitleAndIcon.Left, btnTitleAndIcon.Bottom));
            cmenu.Show(P);
        }

        
        #region 右键菜单操作

        private void 添加本地歌曲ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            OpenFileDialog ofd = new OpenFileDialog();
            if (ofd.ShowDialog() == DialogResult.OK)
            {

            }

        }

        private void 添加本地歌曲文件夹ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            FolderBrowserDialog fbd = new FolderBrowserDialog();
            if (fbd.ShowDialog()==DialogResult.OK)
            {
                
            }
        }

        private void 增大音量ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            VolumeUp(50);
        }

        private void 减小音量ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            VolumeDown(50); 
        }

        private void 显示桌面歌词ToolStripMenuItem_Click(object sender, EventArgs e)
        {

        }

        private void 锁定桌面歌词ToolStripMenuItem_Click(object sender, EventArgs e)
        {

        }

        private void 设置ToolStripMenuItem_Click(object sender, EventArgs e)
        {

        }

        private void 退出ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        #endregion

        #region 音量调节与提示
        /// <summary>
        /// 增大音量
        /// </summary>
        /// <param name="step">音量改变量</param>
        private void VolumeUp(int step)
        {

        }

        /// <summary>
        /// 减小音量
        /// </summary>
        /// <param name="step">音量改变量</param>
        private void VolumeDown(int step)
        {

        }

        private void tbarVolume_ValueChanged(object sender, EventArgs e)
        {

        }

        #endregion

        /// <summary>
        /// 添加本地歌曲文件
        /// </summary>
        /// <param name="filePath">文件完全路径</param>
        private void AddSong(string filePath)
        {

        }

        /// <summary>
        /// 添加本地歌曲文件夹
        /// </summary>
        /// <param name="folderPath">文件夹路径</param>
        private void AddSongFolder(string folderPath)
        {

        }

        //退出时保存设置的音量等信息
        private void MainForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            Properties.Settings.Default.Volume = tbarVolume.Value;

            Properties.Settings.Default.Save();
        }


        private void btnPreSong_MouseClick(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                OpenFileDialog mydlg = new OpenFileDialog();
                mydlg.ShowDialog();

                mySong.FileName = mydlg.FileName;
                //tbarTime.Maximum = mySong.TotalSeconds;

                lblSongName.Text = GetSongName(mydlg.FileName);

                mySong.Play();
                MyTime.Start();

                //DisplayTime(tbarTime.Value, mySong.TotalSeconds);

            }
        }







    }
}
