namespace MusicPlayer
{
    partial class MainForm
    {
        /// <summary>
        /// 必需的设计器变量。
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// 清理所有正在使用的资源。
        /// </summary>
        /// <param name="disposing">如果应释放托管资源，为 true；否则为 false。</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows 窗体设计器生成的代码

        /// <summary>
        /// 设计器支持所需的方法 - 不要
        /// 使用代码编辑器修改此方法的内容。
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(MainForm));
            this.splitContainer1 = new System.Windows.Forms.SplitContainer();
            this.splitContainer2 = new System.Windows.Forms.SplitContainer();
            this.checkBoxEX1 = new MusicPlayer.CheckBoxEX();
            this.lblTotalTime = new System.Windows.Forms.Label();
            this.lblPastTime = new System.Windows.Forms.Label();
            this.lblSongName = new System.Windows.Forms.Label();
            this.playingTrackBar1 = new MusicPlayer.PlayingTrackBar();
            this.volumeMark1 = new MusicPlayer.VolumeMark();
            this.tbarVolume = new TrackBarEx.TrackBarEx();
            this.btnNextSong = new Tian.ButtonEx.ButtonEx();
            this.btnPreSong = new Tian.ButtonEx.ButtonEx();
            this.btnPlayPause = new Tian.ButtonEx.ButtonEx();
            this.mediaContainer1 = new MediaControlLibrary.MediaContainer();
            this.tableLayoutPanel1 = new System.Windows.Forms.TableLayoutPanel();
            this.webBrowser1 = new System.Windows.Forms.WebBrowser();
            this.lyricShow1 = new LyricShow.LyricShow();
            this.tpnlMain = new System.Windows.Forms.TableLayoutPanel();
            this.btnMaximizeBox = new System.Windows.Forms.Button();
            this.btnMinimizeBox = new System.Windows.Forms.Button();
            this.btnTitleAndIcon = new Tian.ButtonEx.ButtonEx();
            this.btnCloseBox = new System.Windows.Forms.Button();
            this.buttonEx1 = new Tian.ButtonEx.ButtonEx();
            this.buttonEx2 = new Tian.ButtonEx.ButtonEx();
            this.buttonEx3 = new Tian.ButtonEx.ButtonEx();
            this.buttonEx4 = new Tian.ButtonEx.ButtonEx();
            this.MyTime = new System.Windows.Forms.Timer(this.components);
            this.cmenu = new Tian.ContexMenuStripEx.ContexMenuStripEx();
            this.文件toolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.添加本地歌曲ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.添加本地歌曲文件夹ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.播放toolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.播放暂停ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem3 = new System.Windows.Forms.ToolStripSeparator();
            this.上一首ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.下一首ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem7 = new System.Windows.Forms.ToolStripSeparator();
            this.增大音量ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.减小音量ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.静音ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem8 = new System.Windows.Forms.ToolStripSeparator();
            this.播放模式ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem6 = new System.Windows.Forms.ToolStripSeparator();
            this.显示桌面歌词ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.锁定桌面歌词ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem1 = new System.Windows.Forms.ToolStripSeparator();
            this.设置ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem2 = new System.Windows.Forms.ToolStripSeparator();
            this.退出ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.cmenuMaxMode = new Tian.ContexMenuStripEx.ContexMenuStripEx();
            this.音乐魔方模式ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.最大化ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem4 = new System.Windows.Forms.ToolStripSeparator();
            this.记住我的选择ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer1)).BeginInit();
            this.splitContainer1.Panel1.SuspendLayout();
            this.splitContainer1.Panel2.SuspendLayout();
            this.splitContainer1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer2)).BeginInit();
            this.splitContainer2.Panel1.SuspendLayout();
            this.splitContainer2.Panel2.SuspendLayout();
            this.splitContainer2.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.btnNextSong)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.btnPreSong)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.btnPlayPause)).BeginInit();
            this.tableLayoutPanel1.SuspendLayout();
            this.tpnlMain.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.btnTitleAndIcon)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.buttonEx1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.buttonEx2)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.buttonEx3)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.buttonEx4)).BeginInit();
            this.cmenu.SuspendLayout();
            this.cmenuMaxMode.SuspendLayout();
            this.SuspendLayout();
            // 
            // splitContainer1
            // 
            this.tpnlMain.SetColumnSpan(this.splitContainer1, 9);
            this.splitContainer1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.splitContainer1.FixedPanel = System.Windows.Forms.FixedPanel.Panel1;
            this.splitContainer1.IsSplitterFixed = true;
            this.splitContainer1.Location = new System.Drawing.Point(2, 30);
            this.splitContainer1.Margin = new System.Windows.Forms.Padding(0);
            this.splitContainer1.Name = "splitContainer1";
            // 
            // splitContainer1.Panel1
            // 
            this.splitContainer1.Panel1.Controls.Add(this.splitContainer2);
            // 
            // splitContainer1.Panel2
            // 
            this.splitContainer1.Panel2.Controls.Add(this.tableLayoutPanel1);
            this.splitContainer1.Size = new System.Drawing.Size(937, 498);
            this.splitContainer1.SplitterDistance = 318;
            this.splitContainer1.SplitterWidth = 1;
            this.splitContainer1.TabIndex = 0;
            // 
            // splitContainer2
            // 
            this.splitContainer2.Dock = System.Windows.Forms.DockStyle.Fill;
            this.splitContainer2.FixedPanel = System.Windows.Forms.FixedPanel.Panel1;
            this.splitContainer2.IsSplitterFixed = true;
            this.splitContainer2.Location = new System.Drawing.Point(0, 0);
            this.splitContainer2.Margin = new System.Windows.Forms.Padding(0);
            this.splitContainer2.Name = "splitContainer2";
            this.splitContainer2.Orientation = System.Windows.Forms.Orientation.Horizontal;
            // 
            // splitContainer2.Panel1
            // 
            this.splitContainer2.Panel1.Controls.Add(this.checkBoxEX1);
            this.splitContainer2.Panel1.Controls.Add(this.lblTotalTime);
            this.splitContainer2.Panel1.Controls.Add(this.lblPastTime);
            this.splitContainer2.Panel1.Controls.Add(this.lblSongName);
            this.splitContainer2.Panel1.Controls.Add(this.playingTrackBar1);
            this.splitContainer2.Panel1.Controls.Add(this.volumeMark1);
            this.splitContainer2.Panel1.Controls.Add(this.tbarVolume);
            this.splitContainer2.Panel1.Controls.Add(this.btnNextSong);
            this.splitContainer2.Panel1.Controls.Add(this.btnPreSong);
            this.splitContainer2.Panel1.Controls.Add(this.btnPlayPause);
            this.splitContainer2.Panel1.ForeColor = System.Drawing.Color.White;
            // 
            // splitContainer2.Panel2
            // 
            this.splitContainer2.Panel2.Controls.Add(this.mediaContainer1);
            this.splitContainer2.Size = new System.Drawing.Size(318, 498);
            this.splitContainer2.SplitterDistance = 103;
            this.splitContainer2.TabIndex = 0;
            // 
            // checkBoxEX1
            // 
            this.checkBoxEX1.AutoSize = true;
            this.checkBoxEX1.BackColor = System.Drawing.Color.Transparent;
            this.checkBoxEX1.Checked = false;
            this.checkBoxEX1.Cursor = System.Windows.Forms.Cursors.Hand;
            this.checkBoxEX1.Location = new System.Drawing.Point(15, 68);
            this.checkBoxEX1.Name = "checkBoxEX1";
            this.checkBoxEX1.Size = new System.Drawing.Size(58, 20);
            this.checkBoxEX1.TabIndex = 7;
            // 
            // lblTotalTime
            // 
            this.lblTotalTime.AutoSize = true;
            this.lblTotalTime.Location = new System.Drawing.Point(266, 37);
            this.lblTotalTime.Name = "lblTotalTime";
            this.lblTotalTime.Size = new System.Drawing.Size(59, 12);
            this.lblTotalTime.TabIndex = 1;
            this.lblTotalTime.Text = "totaltime";
            // 
            // lblPastTime
            // 
            this.lblPastTime.AutoSize = true;
            this.lblPastTime.Location = new System.Drawing.Point(13, 37);
            this.lblPastTime.Name = "lblPastTime";
            this.lblPastTime.Size = new System.Drawing.Size(53, 12);
            this.lblPastTime.TabIndex = 1;
            this.lblPastTime.Text = "timepast";
            // 
            // lblSongName
            // 
            this.lblSongName.AutoSize = true;
            this.lblSongName.Location = new System.Drawing.Point(13, 7);
            this.lblSongName.Name = "lblSongName";
            this.lblSongName.Size = new System.Drawing.Size(41, 12);
            this.lblSongName.TabIndex = 1;
            this.lblSongName.Text = "歌曲名";
            // 
            // playingTrackBar1
            // 
            this.playingTrackBar1.BackColor = System.Drawing.Color.Transparent;
            this.playingTrackBar1.Cursor = System.Windows.Forms.Cursors.Hand;
            this.playingTrackBar1.Location = new System.Drawing.Point(5, 19);
            this.playingTrackBar1.LRMargins = 10;
            this.playingTrackBar1.Name = "playingTrackBar1";
            this.playingTrackBar1.Size = new System.Drawing.Size(311, 18);
            this.playingTrackBar1.TabIndex = 6;
            this.playingTrackBar1.TotalTime = 100;
            this.playingTrackBar1.TrackHeight = 4;
            this.playingTrackBar1.Value = 0;
            // 
            // volumeMark1
            // 
            this.volumeMark1.BackColor = System.Drawing.Color.Transparent;
            this.volumeMark1.Cursor = System.Windows.Forms.Cursors.Hand;
            this.volumeMark1.IsMuted = false;
            this.volumeMark1.Location = new System.Drawing.Point(225, 71);
            this.volumeMark1.Name = "volumeMark1";
            this.volumeMark1.Size = new System.Drawing.Size(24, 18);
            this.volumeMark1.TabIndex = 4;
            this.volumeMark1.Volume = 100;
            // 
            // tbarVolume
            // 
            this.tbarVolume.BackColor = System.Drawing.Color.Transparent;
            this.tbarVolume.Cursor = System.Windows.Forms.Cursors.Hand;
            this.tbarVolume.Location = new System.Drawing.Point(252, 72);
            this.tbarVolume.LRMargins = 3;
            this.tbarVolume.Maximum = 1000;
            this.tbarVolume.Minimum = 0;
            this.tbarVolume.Name = "tbarVolume";
            this.tbarVolume.Size = new System.Drawing.Size(60, 18);
            this.tbarVolume.SmallChange = 50;
            this.tbarVolume.TabIndex = 5;
            this.tbarVolume.TrackHeight = 3;
            this.tbarVolume.UseToControlVolume = true;
            this.tbarVolume.Value = 0;
            this.tbarVolume.ValueChanged += new System.EventHandler(this.tbarVolume_ValueChanged);
            // 
            // btnNextSong
            // 
            this.btnNextSong.BackColor = System.Drawing.Color.Transparent;
            this.btnNextSong.ButtonMode = Tian.ButtonEx.ButtonEx.buttonmode.PlayControl;
            this.btnNextSong.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnNextSong.Image = global::MusicPlayer.Properties.Resources.下一曲;
            this.btnNextSong.Location = new System.Drawing.Point(174, 62);
            this.btnNextSong.Name = "btnNextSong";
            this.btnNextSong.Size = new System.Drawing.Size(37, 30);
            this.btnNextSong.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.btnNextSong.TabIndex = 3;
            this.btnNextSong.TabStop = false;
            this.btnNextSong.Text = "buttonEx1";
            this.btnNextSong.Click += new System.EventHandler(this.btnNextSong_Click);
            // 
            // btnPreSong
            // 
            this.btnPreSong.BackColor = System.Drawing.Color.Transparent;
            this.btnPreSong.ButtonMode = Tian.ButtonEx.ButtonEx.buttonmode.PlayControl;
            this.btnPreSong.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnPreSong.Image = global::MusicPlayer.Properties.Resources.上一曲;
            this.btnPreSong.Location = new System.Drawing.Point(90, 62);
            this.btnPreSong.Name = "btnPreSong";
            this.btnPreSong.Size = new System.Drawing.Size(37, 30);
            this.btnPreSong.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.btnPreSong.TabIndex = 3;
            this.btnPreSong.TabStop = false;
            this.btnPreSong.Text = "buttonEx1";
            this.btnPreSong.Click += new System.EventHandler(this.btnPreSong_Click);
            this.btnPreSong.MouseClick += new System.Windows.Forms.MouseEventHandler(this.btnPreSong_MouseClick);
            // 
            // btnPlayPause
            // 
            this.btnPlayPause.BackColor = System.Drawing.Color.Transparent;
            this.btnPlayPause.ButtonMode = Tian.ButtonEx.ButtonEx.buttonmode.PlayControl;
            this.btnPlayPause.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnPlayPause.Image = global::MusicPlayer.Properties.Resources.播放;
            this.btnPlayPause.Location = new System.Drawing.Point(130, 56);
            this.btnPlayPause.Name = "btnPlayPause";
            this.btnPlayPause.Size = new System.Drawing.Size(41, 36);
            this.btnPlayPause.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.btnPlayPause.TabIndex = 3;
            this.btnPlayPause.TabStop = false;
            this.btnPlayPause.Text = "buttonEx1";
            this.btnPlayPause.Click += new System.EventHandler(this.btnPlayPause_Click);
            // 
            // mediaContainer1
            // 
            this.mediaContainer1.BackColor = System.Drawing.Color.White;
            this.mediaContainer1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.mediaContainer1.ForeColor = System.Drawing.Color.Black;
            this.mediaContainer1.ItemFont = new System.Drawing.Font("宋体", 10F);
            this.mediaContainer1.ListFont = new System.Drawing.Font("宋体", 10F, System.Drawing.FontStyle.Bold);
            this.mediaContainer1.ListForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(71)))), ((int)(((byte)(71)))), ((int)(((byte)(71)))));
            this.mediaContainer1.Location = new System.Drawing.Point(0, 0);
            this.mediaContainer1.MediaItemBackColor = System.Drawing.Color.Empty;
            this.mediaContainer1.MediaItemForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(117)))), ((int)(((byte)(117)))), ((int)(((byte)(117)))));
            this.mediaContainer1.MediaItemMouseOnColor = System.Drawing.Color.FromArgb(((int)(((byte)(224)))), ((int)(((byte)(238)))), ((int)(((byte)(238)))));
            this.mediaContainer1.MediaItemPlayingColor = System.Drawing.Color.FromArgb(((int)(((byte)(159)))), ((int)(((byte)(182)))), ((int)(((byte)(205)))));
            this.mediaContainer1.MediaItemSelectedColor = System.Drawing.Color.FromArgb(((int)(((byte)(185)))), ((int)(((byte)(211)))), ((int)(((byte)(238)))));
            this.mediaContainer1.MediaListBackColor = System.Drawing.Color.Empty;
            this.mediaContainer1.MediaListMouseOnColor = System.Drawing.Color.Empty;
            this.mediaContainer1.MultiSelected = false;
            this.mediaContainer1.Name = "mediaContainer1";
            this.mediaContainer1.PlayingMediaItem = null;
            this.mediaContainer1.Size = new System.Drawing.Size(318, 391);
            this.mediaContainer1.TabIndex = 3;
            this.mediaContainer1.Text = "mediaContainer1";
            this.mediaContainer1.VScrollSliderColor = System.Drawing.Color.DarkGray;
            this.mediaContainer1.VScrollSliderMouseOnColor = System.Drawing.Color.Gray;
            // 
            // tableLayoutPanel1
            // 
            this.tableLayoutPanel1.ColumnCount = 2;
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel1.Controls.Add(this.webBrowser1, 0, 1);
            this.tableLayoutPanel1.Controls.Add(this.lyricShow1, 1, 0);
            this.tableLayoutPanel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel1.Location = new System.Drawing.Point(0, 0);
            this.tableLayoutPanel1.Name = "tableLayoutPanel1";
            this.tableLayoutPanel1.RowCount = 2;
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 108F));
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel1.Size = new System.Drawing.Size(618, 498);
            this.tableLayoutPanel1.TabIndex = 1;
            // 
            // webBrowser1
            // 
            this.tableLayoutPanel1.SetColumnSpan(this.webBrowser1, 2);
            this.webBrowser1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.webBrowser1.IsWebBrowserContextMenuEnabled = false;
            this.webBrowser1.Location = new System.Drawing.Point(0, 108);
            this.webBrowser1.Margin = new System.Windows.Forms.Padding(0);
            this.webBrowser1.MinimumSize = new System.Drawing.Size(20, 20);
            this.webBrowser1.Name = "webBrowser1";
            this.webBrowser1.ScriptErrorsSuppressed = true;
            this.webBrowser1.ScrollBarsEnabled = false;
            this.webBrowser1.Size = new System.Drawing.Size(618, 390);
            this.webBrowser1.TabIndex = 0;
            // 
            // lyricShow1
            // 
            this.lyricShow1.CurrentProgress = 0D;
            this.lyricShow1.DContextMenu = null;
            this.lyricShow1.DesktopLyricBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(128)))), ((int)(((byte)(128)))), ((int)(((byte)(128)))));
            this.lyricShow1.DesktopLyricBorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(0)))), ((int)(((byte)(0)))));
            this.lyricShow1.DesktopLyricHighlightTextColor = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(255)))), ((int)(((byte)(0)))));
            this.lyricShow1.DesktopLyricHighlightTextColor1 = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(232)))), ((int)(((byte)(137)))));
            this.lyricShow1.DesktopLyricTextColor = System.Drawing.Color.FromArgb(((int)(((byte)(144)))), ((int)(((byte)(210)))), ((int)(((byte)(248)))));
            this.lyricShow1.DesktopLyricTextColor1 = System.Drawing.Color.FromArgb(((int)(((byte)(55)))), ((int)(((byte)(137)))), ((int)(((byte)(221)))));
            this.lyricShow1.Font = new System.Drawing.Font("微软雅黑", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.lyricShow1.Location = new System.Drawing.Point(312, 3);
            this.lyricShow1.LyricHighlightTextColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(0)))), ((int)(((byte)(0)))));
            this.lyricShow1.LyricPath = null;
            this.lyricShow1.LyricTextColor = System.Drawing.Color.FromArgb(((int)(((byte)(153)))), ((int)(((byte)(153)))), ((int)(((byte)(153)))));
            this.lyricShow1.Name = "lyricShow1";
            this.lyricShow1.Size = new System.Drawing.Size(296, 89);
            this.lyricShow1.TabIndex = 2;
            this.lyricShow1.Text = "lyricShow1";
            // 
            // tpnlMain
            // 
            this.tpnlMain.BackColor = System.Drawing.Color.Transparent;
            this.tpnlMain.ColumnCount = 9;
            this.tpnlMain.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 40F));
            this.tpnlMain.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 65F));
            this.tpnlMain.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 65F));
            this.tpnlMain.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 65F));
            this.tpnlMain.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 65F));
            this.tpnlMain.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tpnlMain.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 23F));
            this.tpnlMain.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 23F));
            this.tpnlMain.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 25F));
            this.tpnlMain.Controls.Add(this.btnMaximizeBox, 7, 0);
            this.tpnlMain.Controls.Add(this.btnMinimizeBox, 6, 0);
            this.tpnlMain.Controls.Add(this.btnTitleAndIcon, 0, 0);
            this.tpnlMain.Controls.Add(this.btnCloseBox, 8, 0);
            this.tpnlMain.Controls.Add(this.splitContainer1, 0, 1);
            this.tpnlMain.Controls.Add(this.buttonEx1, 1, 2);
            this.tpnlMain.Controls.Add(this.buttonEx2, 3, 2);
            this.tpnlMain.Controls.Add(this.buttonEx3, 4, 2);
            this.tpnlMain.Controls.Add(this.buttonEx4, 2, 2);
            this.tpnlMain.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tpnlMain.Location = new System.Drawing.Point(0, 0);
            this.tpnlMain.Name = "tpnlMain";
            this.tpnlMain.Padding = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.tpnlMain.RowCount = 3;
            this.tpnlMain.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 30F));
            this.tpnlMain.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tpnlMain.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 33F));
            this.tpnlMain.Size = new System.Drawing.Size(941, 561);
            this.tpnlMain.TabIndex = 1;
            this.tpnlMain.MouseDown += new System.Windows.Forms.MouseEventHandler(this.tpnlMain_MouseDown);
            // 
            // btnMaximizeBox
            // 
            this.btnMaximizeBox.BackgroundImage = global::MusicPlayer.Properties.Resources.窗口模式;
            this.btnMaximizeBox.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.btnMaximizeBox.FlatAppearance.BorderSize = 0;
            this.btnMaximizeBox.FlatAppearance.MouseDownBackColor = System.Drawing.Color.DodgerBlue;
            this.btnMaximizeBox.FlatAppearance.MouseOverBackColor = System.Drawing.Color.DeepSkyBlue;
            this.btnMaximizeBox.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnMaximizeBox.Location = new System.Drawing.Point(894, 3);
            this.btnMaximizeBox.Name = "btnMaximizeBox";
            this.btnMaximizeBox.Size = new System.Drawing.Size(17, 20);
            this.btnMaximizeBox.TabIndex = 1;
            this.btnMaximizeBox.UseVisualStyleBackColor = true;
            this.btnMaximizeBox.Click += new System.EventHandler(this.btnMaximizeBox_Click);
            // 
            // btnMinimizeBox
            // 
            this.btnMinimizeBox.BackgroundImage = global::MusicPlayer.Properties.Resources.最小化;
            this.btnMinimizeBox.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.btnMinimizeBox.FlatAppearance.BorderSize = 0;
            this.btnMinimizeBox.FlatAppearance.MouseDownBackColor = System.Drawing.Color.DodgerBlue;
            this.btnMinimizeBox.FlatAppearance.MouseOverBackColor = System.Drawing.Color.DeepSkyBlue;
            this.btnMinimizeBox.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnMinimizeBox.Location = new System.Drawing.Point(871, 3);
            this.btnMinimizeBox.Name = "btnMinimizeBox";
            this.btnMinimizeBox.Size = new System.Drawing.Size(17, 20);
            this.btnMinimizeBox.TabIndex = 1;
            this.btnMinimizeBox.UseVisualStyleBackColor = true;
            this.btnMinimizeBox.Click += new System.EventHandler(this.btnMinimizeBox_Click);
            // 
            // btnTitleAndIcon
            // 
            this.btnTitleAndIcon.BackColor = System.Drawing.Color.Transparent;
            this.btnTitleAndIcon.ButtonMode = Tian.ButtonEx.ButtonEx.buttonmode.PlayControl;
            this.tpnlMain.SetColumnSpan(this.btnTitleAndIcon, 3);
            this.btnTitleAndIcon.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnTitleAndIcon.Image = ((System.Drawing.Image)(resources.GetObject("btnTitleAndIcon.Image")));
            this.btnTitleAndIcon.Location = new System.Drawing.Point(5, 3);
            this.btnTitleAndIcon.Name = "btnTitleAndIcon";
            this.btnTitleAndIcon.Size = new System.Drawing.Size(59, 24);
            this.btnTitleAndIcon.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.btnTitleAndIcon.TabIndex = 5;
            this.btnTitleAndIcon.TabStop = false;
            this.btnTitleAndIcon.Click += new System.EventHandler(this.btnTitleAndIcon_Click);
            // 
            // btnCloseBox
            // 
            this.btnCloseBox.BackgroundImage = global::MusicPlayer.Properties.Resources.关闭;
            this.btnCloseBox.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.btnCloseBox.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.btnCloseBox.FlatAppearance.BorderSize = 0;
            this.btnCloseBox.FlatAppearance.MouseDownBackColor = System.Drawing.Color.Maroon;
            this.btnCloseBox.FlatAppearance.MouseOverBackColor = System.Drawing.Color.Red;
            this.btnCloseBox.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnCloseBox.Location = new System.Drawing.Point(917, 3);
            this.btnCloseBox.Name = "btnCloseBox";
            this.btnCloseBox.Size = new System.Drawing.Size(19, 20);
            this.btnCloseBox.TabIndex = 1;
            this.btnCloseBox.UseVisualStyleBackColor = true;
            this.btnCloseBox.Click += new System.EventHandler(this.btnCloseBox_Click);
            // 
            // buttonEx1
            // 
            this.buttonEx1.BackColor = System.Drawing.Color.Transparent;
            this.buttonEx1.BackgroundImage = global::MusicPlayer.Properties.Resources.圆形背景;
            this.buttonEx1.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.buttonEx1.ButtonMode = Tian.ButtonEx.ButtonEx.buttonmode.FunctionBtuuon;
            this.buttonEx1.Cursor = System.Windows.Forms.Cursors.Hand;
            this.buttonEx1.Image = global::MusicPlayer.Properties.Resources.添加;
            this.buttonEx1.Location = new System.Drawing.Point(45, 531);
            this.buttonEx1.Name = "buttonEx1";
            this.buttonEx1.Size = new System.Drawing.Size(27, 27);
            this.buttonEx1.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.buttonEx1.TabIndex = 4;
            this.buttonEx1.TabStop = false;
            this.buttonEx1.Text = "buttonEx1";
            // 
            // buttonEx2
            // 
            this.buttonEx2.BackColor = System.Drawing.Color.Transparent;
            this.buttonEx2.BackgroundImage = global::MusicPlayer.Properties.Resources.圆形背景;
            this.buttonEx2.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.buttonEx2.ButtonMode = Tian.ButtonEx.ButtonEx.buttonmode.FunctionBtuuon;
            this.buttonEx2.Cursor = System.Windows.Forms.Cursors.Hand;
            this.buttonEx2.Image = global::MusicPlayer.Properties.Resources.单曲循环;
            this.buttonEx2.Location = new System.Drawing.Point(175, 531);
            this.buttonEx2.Name = "buttonEx2";
            this.buttonEx2.Size = new System.Drawing.Size(27, 27);
            this.buttonEx2.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.buttonEx2.TabIndex = 4;
            this.buttonEx2.TabStop = false;
            this.buttonEx2.Text = "buttonEx1";
            // 
            // buttonEx3
            // 
            this.buttonEx3.BackColor = System.Drawing.Color.Transparent;
            this.buttonEx3.BackgroundImage = global::MusicPlayer.Properties.Resources.圆形背景;
            this.buttonEx3.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.buttonEx3.ButtonMode = Tian.ButtonEx.ButtonEx.buttonmode.FunctionBtuuon;
            this.buttonEx3.Cursor = System.Windows.Forms.Cursors.Hand;
            this.buttonEx3.Image = global::MusicPlayer.Properties.Resources.查找;
            this.buttonEx3.Location = new System.Drawing.Point(240, 531);
            this.buttonEx3.Name = "buttonEx3";
            this.buttonEx3.Size = new System.Drawing.Size(27, 27);
            this.buttonEx3.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.buttonEx3.TabIndex = 4;
            this.buttonEx3.TabStop = false;
            this.buttonEx3.Text = "buttonEx1";
            // 
            // buttonEx4
            // 
            this.buttonEx4.BackColor = System.Drawing.Color.Transparent;
            this.buttonEx4.BackgroundImage = global::MusicPlayer.Properties.Resources.圆形背景;
            this.buttonEx4.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.buttonEx4.ButtonMode = Tian.ButtonEx.ButtonEx.buttonmode.FunctionBtuuon;
            this.buttonEx4.Cursor = System.Windows.Forms.Cursors.Hand;
            this.buttonEx4.Image = global::MusicPlayer.Properties.Resources.定位;
            this.buttonEx4.Location = new System.Drawing.Point(110, 531);
            this.buttonEx4.Name = "buttonEx4";
            this.buttonEx4.Size = new System.Drawing.Size(27, 27);
            this.buttonEx4.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.buttonEx4.TabIndex = 4;
            this.buttonEx4.TabStop = false;
            this.buttonEx4.Text = "buttonEx1";
            // 
            // MyTime
            // 
            this.MyTime.Enabled = true;
            this.MyTime.Interval = 1;
            this.MyTime.Tick += new System.EventHandler(this.MyTime_Tick);
            // 
            // cmenu
            // 
            this.cmenu.ArrawColor = System.Drawing.Color.Black;
            this.cmenu.BackColor = System.Drawing.Color.Transparent;
            this.cmenu.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.文件toolStripMenuItem,
            this.播放toolStripMenuItem,
            this.toolStripMenuItem6,
            this.显示桌面歌词ToolStripMenuItem,
            this.锁定桌面歌词ToolStripMenuItem,
            this.toolStripMenuItem1,
            this.设置ToolStripMenuItem,
            this.toolStripMenuItem2,
            this.退出ToolStripMenuItem});
            this.cmenu.ItemSelectedColor = System.Drawing.Color.Blue;
            this.cmenu.Name = "contexMenuStripEx1";
            this.cmenu.SeperatorColor = System.Drawing.Color.DarkGray;
            this.cmenu.Size = new System.Drawing.Size(149, 154);
            // 
            // 文件toolStripMenuItem
            // 
            this.文件toolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.添加本地歌曲ToolStripMenuItem,
            this.添加本地歌曲文件夹ToolStripMenuItem});
            this.文件toolStripMenuItem.Name = "文件toolStripMenuItem";
            this.文件toolStripMenuItem.Size = new System.Drawing.Size(148, 22);
            this.文件toolStripMenuItem.Text = "文件";
            // 
            // 添加本地歌曲ToolStripMenuItem
            // 
            this.添加本地歌曲ToolStripMenuItem.Name = "添加本地歌曲ToolStripMenuItem";
            this.添加本地歌曲ToolStripMenuItem.Size = new System.Drawing.Size(184, 22);
            this.添加本地歌曲ToolStripMenuItem.Text = "添加本地歌曲";
            this.添加本地歌曲ToolStripMenuItem.Click += new System.EventHandler(this.添加本地歌曲ToolStripMenuItem_Click);
            // 
            // 添加本地歌曲文件夹ToolStripMenuItem
            // 
            this.添加本地歌曲文件夹ToolStripMenuItem.Name = "添加本地歌曲文件夹ToolStripMenuItem";
            this.添加本地歌曲文件夹ToolStripMenuItem.Size = new System.Drawing.Size(184, 22);
            this.添加本地歌曲文件夹ToolStripMenuItem.Text = "添加本地歌曲文件夹";
            this.添加本地歌曲文件夹ToolStripMenuItem.Click += new System.EventHandler(this.添加本地歌曲文件夹ToolStripMenuItem_Click);
            // 
            // 播放toolStripMenuItem
            // 
            this.播放toolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.播放暂停ToolStripMenuItem,
            this.toolStripMenuItem3,
            this.上一首ToolStripMenuItem,
            this.下一首ToolStripMenuItem,
            this.toolStripMenuItem7,
            this.增大音量ToolStripMenuItem,
            this.减小音量ToolStripMenuItem,
            this.静音ToolStripMenuItem,
            this.toolStripMenuItem8,
            this.播放模式ToolStripMenuItem});
            this.播放toolStripMenuItem.Name = "播放toolStripMenuItem";
            this.播放toolStripMenuItem.Size = new System.Drawing.Size(148, 22);
            this.播放toolStripMenuItem.Text = "播放";
            // 
            // 播放暂停ToolStripMenuItem
            // 
            this.播放暂停ToolStripMenuItem.Name = "播放暂停ToolStripMenuItem";
            this.播放暂停ToolStripMenuItem.Size = new System.Drawing.Size(129, 22);
            this.播放暂停ToolStripMenuItem.Text = "播放/暂停";
            this.播放暂停ToolStripMenuItem.Click += new System.EventHandler(this.btnPlayPause_Click);
            // 
            // toolStripMenuItem3
            // 
            this.toolStripMenuItem3.Name = "toolStripMenuItem3";
            this.toolStripMenuItem3.Size = new System.Drawing.Size(126, 6);
            // 
            // 上一首ToolStripMenuItem
            // 
            this.上一首ToolStripMenuItem.Name = "上一首ToolStripMenuItem";
            this.上一首ToolStripMenuItem.Size = new System.Drawing.Size(129, 22);
            this.上一首ToolStripMenuItem.Text = "上一首";
            this.上一首ToolStripMenuItem.Click += new System.EventHandler(this.btnPreSong_Click);
            // 
            // 下一首ToolStripMenuItem
            // 
            this.下一首ToolStripMenuItem.Name = "下一首ToolStripMenuItem";
            this.下一首ToolStripMenuItem.Size = new System.Drawing.Size(129, 22);
            this.下一首ToolStripMenuItem.Text = "下一首";
            this.下一首ToolStripMenuItem.Click += new System.EventHandler(this.btnNextSong_Click);
            // 
            // toolStripMenuItem7
            // 
            this.toolStripMenuItem7.Name = "toolStripMenuItem7";
            this.toolStripMenuItem7.Size = new System.Drawing.Size(126, 6);
            // 
            // 增大音量ToolStripMenuItem
            // 
            this.增大音量ToolStripMenuItem.Name = "增大音量ToolStripMenuItem";
            this.增大音量ToolStripMenuItem.Size = new System.Drawing.Size(129, 22);
            this.增大音量ToolStripMenuItem.Text = "增大音量";
            this.增大音量ToolStripMenuItem.Click += new System.EventHandler(this.增大音量ToolStripMenuItem_Click);
            // 
            // 减小音量ToolStripMenuItem
            // 
            this.减小音量ToolStripMenuItem.Name = "减小音量ToolStripMenuItem";
            this.减小音量ToolStripMenuItem.Size = new System.Drawing.Size(129, 22);
            this.减小音量ToolStripMenuItem.Text = "减小音量";
            this.减小音量ToolStripMenuItem.Click += new System.EventHandler(this.减小音量ToolStripMenuItem_Click);
            // 
            // 静音ToolStripMenuItem
            // 
            this.静音ToolStripMenuItem.CheckOnClick = true;
            this.静音ToolStripMenuItem.Name = "静音ToolStripMenuItem";
            this.静音ToolStripMenuItem.Size = new System.Drawing.Size(129, 22);
            this.静音ToolStripMenuItem.Text = "静音";
            // 
            // toolStripMenuItem8
            // 
            this.toolStripMenuItem8.Name = "toolStripMenuItem8";
            this.toolStripMenuItem8.Size = new System.Drawing.Size(126, 6);
            // 
            // 播放模式ToolStripMenuItem
            // 
            this.播放模式ToolStripMenuItem.Name = "播放模式ToolStripMenuItem";
            this.播放模式ToolStripMenuItem.Size = new System.Drawing.Size(129, 22);
            this.播放模式ToolStripMenuItem.Text = "播放模式";
            // 
            // toolStripMenuItem6
            // 
            this.toolStripMenuItem6.Name = "toolStripMenuItem6";
            this.toolStripMenuItem6.Size = new System.Drawing.Size(145, 6);
            // 
            // 显示桌面歌词ToolStripMenuItem
            // 
            this.显示桌面歌词ToolStripMenuItem.Name = "显示桌面歌词ToolStripMenuItem";
            this.显示桌面歌词ToolStripMenuItem.Size = new System.Drawing.Size(148, 22);
            this.显示桌面歌词ToolStripMenuItem.Text = "显示桌面歌词";
            this.显示桌面歌词ToolStripMenuItem.Click += new System.EventHandler(this.显示桌面歌词ToolStripMenuItem_Click);
            // 
            // 锁定桌面歌词ToolStripMenuItem
            // 
            this.锁定桌面歌词ToolStripMenuItem.Name = "锁定桌面歌词ToolStripMenuItem";
            this.锁定桌面歌词ToolStripMenuItem.Size = new System.Drawing.Size(148, 22);
            this.锁定桌面歌词ToolStripMenuItem.Text = "锁定桌面歌词";
            this.锁定桌面歌词ToolStripMenuItem.Click += new System.EventHandler(this.锁定桌面歌词ToolStripMenuItem_Click);
            // 
            // toolStripMenuItem1
            // 
            this.toolStripMenuItem1.Name = "toolStripMenuItem1";
            this.toolStripMenuItem1.Size = new System.Drawing.Size(145, 6);
            // 
            // 设置ToolStripMenuItem
            // 
            this.设置ToolStripMenuItem.Name = "设置ToolStripMenuItem";
            this.设置ToolStripMenuItem.Size = new System.Drawing.Size(148, 22);
            this.设置ToolStripMenuItem.Text = "设置";
            this.设置ToolStripMenuItem.Click += new System.EventHandler(this.设置ToolStripMenuItem_Click);
            // 
            // toolStripMenuItem2
            // 
            this.toolStripMenuItem2.Name = "toolStripMenuItem2";
            this.toolStripMenuItem2.Size = new System.Drawing.Size(145, 6);
            // 
            // 退出ToolStripMenuItem
            // 
            this.退出ToolStripMenuItem.Name = "退出ToolStripMenuItem";
            this.退出ToolStripMenuItem.Size = new System.Drawing.Size(148, 22);
            this.退出ToolStripMenuItem.Text = "退出";
            this.退出ToolStripMenuItem.Click += new System.EventHandler(this.退出ToolStripMenuItem_Click);
            // 
            // cmenuMaxMode
            // 
            this.cmenuMaxMode.ArrawColor = System.Drawing.Color.Black;
            this.cmenuMaxMode.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(100)))), ((int)(((byte)(255)))), ((int)(((byte)(255)))), ((int)(((byte)(255)))));
            this.cmenuMaxMode.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.音乐魔方模式ToolStripMenuItem,
            this.最大化ToolStripMenuItem,
            this.toolStripMenuItem4,
            this.记住我的选择ToolStripMenuItem});
            this.cmenuMaxMode.ItemSelectedColor = System.Drawing.Color.Blue;
            this.cmenuMaxMode.Name = "cmenuMaxMode";
            this.cmenuMaxMode.SeperatorColor = System.Drawing.Color.DarkGray;
            this.cmenuMaxMode.Size = new System.Drawing.Size(149, 76);
            // 
            // 音乐魔方模式ToolStripMenuItem
            // 
            this.音乐魔方模式ToolStripMenuItem.Name = "音乐魔方模式ToolStripMenuItem";
            this.音乐魔方模式ToolStripMenuItem.Size = new System.Drawing.Size(148, 22);
            this.音乐魔方模式ToolStripMenuItem.Text = "音乐魔方模式";
            this.音乐魔方模式ToolStripMenuItem.Click += new System.EventHandler(this.音乐魔方模式ToolStripMenuItem_Click);
            // 
            // 最大化ToolStripMenuItem
            // 
            this.最大化ToolStripMenuItem.Name = "最大化ToolStripMenuItem";
            this.最大化ToolStripMenuItem.Size = new System.Drawing.Size(148, 22);
            this.最大化ToolStripMenuItem.Text = "最大化";
            this.最大化ToolStripMenuItem.Click += new System.EventHandler(this.最大化ToolStripMenuItem_Click);
            // 
            // toolStripMenuItem4
            // 
            this.toolStripMenuItem4.Name = "toolStripMenuItem4";
            this.toolStripMenuItem4.Size = new System.Drawing.Size(145, 6);
            // 
            // 记住我的选择ToolStripMenuItem
            // 
            this.记住我的选择ToolStripMenuItem.Name = "记住我的选择ToolStripMenuItem";
            this.记住我的选择ToolStripMenuItem.Size = new System.Drawing.Size(148, 22);
            this.记住我的选择ToolStripMenuItem.Text = "记住我的选择";
            this.记住我的选择ToolStripMenuItem.Click += new System.EventHandler(this.记住我的选择ToolStripMenuItem_Click);
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.DodgerBlue;
            this.ClientSize = new System.Drawing.Size(941, 561);
            this.Controls.Add(this.tpnlMain);
            this.DoubleBuffered = true;
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "MainForm";
            this.Text = "Form1";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.MainForm_FormClosing);
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.MainForm_FormClosed);
            this.Load += new System.EventHandler(this.MainForm_Load);
            this.splitContainer1.Panel1.ResumeLayout(false);
            this.splitContainer1.Panel2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer1)).EndInit();
            this.splitContainer1.ResumeLayout(false);
            this.splitContainer2.Panel1.ResumeLayout(false);
            this.splitContainer2.Panel1.PerformLayout();
            this.splitContainer2.Panel2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer2)).EndInit();
            this.splitContainer2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.btnNextSong)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.btnPreSong)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.btnPlayPause)).EndInit();
            this.tableLayoutPanel1.ResumeLayout(false);
            this.tpnlMain.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.btnTitleAndIcon)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.buttonEx1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.buttonEx2)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.buttonEx3)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.buttonEx4)).EndInit();
            this.cmenu.ResumeLayout(false);
            this.cmenuMaxMode.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.SplitContainer splitContainer1;
        private System.Windows.Forms.TableLayoutPanel tpnlMain;
        private System.Windows.Forms.Button btnMinimizeBox;
        private System.Windows.Forms.Button btnMaximizeBox;
        private System.Windows.Forms.Button btnCloseBox;
        private System.Windows.Forms.Label lblPastTime;
        private System.Windows.Forms.Label lblTotalTime;
        private System.Windows.Forms.Label lblSongName;
        private System.Windows.Forms.SplitContainer splitContainer2;
        private Tian.ContexMenuStripEx.ContexMenuStripEx cmenu;
        private System.Windows.Forms.ToolStripMenuItem 文件toolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem 播放toolStripMenuItem;
        private System.Windows.Forms.ToolStripSeparator toolStripMenuItem6;
        private System.Windows.Forms.ToolStripMenuItem 显示桌面歌词ToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem 锁定桌面歌词ToolStripMenuItem;
        private System.Windows.Forms.ToolStripSeparator toolStripMenuItem1;
        private System.Windows.Forms.ToolStripMenuItem 设置ToolStripMenuItem;
        private System.Windows.Forms.ToolStripSeparator toolStripMenuItem2;
        private System.Windows.Forms.ToolStripMenuItem 退出ToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem 添加本地歌曲ToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem 添加本地歌曲文件夹ToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem 播放暂停ToolStripMenuItem;
        private System.Windows.Forms.ToolStripSeparator toolStripMenuItem3;
        private System.Windows.Forms.ToolStripMenuItem 上一首ToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem 下一首ToolStripMenuItem;
        private System.Windows.Forms.ToolStripSeparator toolStripMenuItem7;
        private System.Windows.Forms.ToolStripMenuItem 增大音量ToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem 减小音量ToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem 静音ToolStripMenuItem;
        private System.Windows.Forms.ToolStripSeparator toolStripMenuItem8;
        private System.Windows.Forms.ToolStripMenuItem 播放模式ToolStripMenuItem;
        private Tian.ButtonEx.ButtonEx btnNextSong;
        private Tian.ButtonEx.ButtonEx btnPreSong;
        private Tian.ButtonEx.ButtonEx btnPlayPause;
        private System.Windows.Forms.WebBrowser webBrowser1;
        private Tian.ButtonEx.ButtonEx buttonEx1;
        private Tian.ButtonEx.ButtonEx btnTitleAndIcon;
        private Tian.ButtonEx.ButtonEx buttonEx2;
        private Tian.ButtonEx.ButtonEx buttonEx3;
        private Tian.ButtonEx.ButtonEx buttonEx4;
        private Tian.ContexMenuStripEx.ContexMenuStripEx cmenuMaxMode;
        private System.Windows.Forms.ToolStripMenuItem 音乐魔方模式ToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem 最大化ToolStripMenuItem;
        private System.Windows.Forms.ToolStripSeparator toolStripMenuItem4;
        private System.Windows.Forms.ToolStripMenuItem 记住我的选择ToolStripMenuItem;
        private TrackBarEx.TrackBarEx tbarVolume;
        private System.Windows.Forms.Timer MyTime;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel1;
        private LyricShow.LyricShow lyricShow1;
        private MediaControlLibrary.MediaContainer mediaContainer1;
        private VolumeMark volumeMark1;
        private PlayingTrackBar playingTrackBar1;
        private CheckBoxEX checkBoxEX1;
    }
}

