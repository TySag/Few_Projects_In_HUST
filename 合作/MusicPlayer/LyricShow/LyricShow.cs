using System;
using System.ComponentModel;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.IO;
using System.Windows.Forms;

namespace LyricShow
{
    public class LyricShow : Control
    {
        private Panel panel1;

        public LyricShow()
        {
            //初始化窗体
            this.panel1 = new System.Windows.Forms.Panel();
            this.panel1.Location = new System.Drawing.Point(5, 5);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(140, 140);
            this.panel1.TabIndex = 0;
            this.panel1.Visible = false;
            ResetSkin();

            this.SetStyle(ControlStyles.AllPaintingInWmPaint | ControlStyles.OptimizedDoubleBuffer | ControlStyles.UserPaint, true);
        }

        Lyric lyric; string lpath;                                //主要歌词和歌词路径
        double current;                                           //当前时间
        frmDesktopLyric fdl = new frmDesktopLyric();              //桌面歌词模块
        bool hid = true;                                          //表示是否已经隐藏了桌面歌词

        Color ltcolor = Color.FromArgb(153, 153, 153),            //歌词文本颜色
              lhtcolor = Color.FromArgb(0, 0, 0),                 //歌词文本高亮颜色
              dtcolor = Color.FromArgb(144, 210, 248),            //桌面歌词文本颜色1
              dtcolor1 = Color.FromArgb(55, 137, 221),            //桌面歌词文本颜色2
              dhtcolor = Color.FromArgb(255, 255, 0),             //桌面歌词高亮颜色1
              dhtcolor1 = Color.FromArgb(255, 232, 137),          //桌面歌词高亮颜色2
              dbcolor = Color.FromArgb(128, 128, 128),            //桌面歌词背景颜色
              dbordercolor = Color.FromArgb(0, 0, 0);             //桌面歌词边框颜色
        Font dfont = new Font("微软雅黑", 30, FontStyle.Bold);    //桌面歌词的文本字体
        int dAngle = 90;                                          //桌面歌词渐变填充的旋转度数
        double dtOpacity = 1;                                     //桌面歌词文本透明度（取值：0≤dtOpacity≤1）
        double dbOpacity = 0.5;                                   //桌面歌词背景透明度（取值：0≤dbOpacity≤1）

        #region 属性
        /// <summary>
        /// 返回或设置歌词的文本颜色
        /// </summary>
        [Description("返回或设置歌词的文本颜色")]
        public Color LyricTextColor
        {
            get { return ltcolor; }
            set
            {
                ltcolor = value;
                this.Invalidate();
            }
        }

        /// <summary>
        /// 返回或设置歌词的高亮文本颜色
        /// </summary>
        [Description("返回或设置歌词的高亮文本颜色")]
        public Color LyricHighlightTextColor
        {
            get { return lhtcolor; }
            set
            {
                lhtcolor = value;
                this.Invalidate();
            }
        }

        /// <summary>
        /// 返回或设置桌面歌词的渐变起始颜色
        /// </summary>
        [Description("返回或设置桌面歌词的渐变起始颜色")]
        public Color DesktopLyricTextColor
        {
            get { return dtcolor; }
            set
            {
                dtcolor = value;
                ResetSkin();
            }
        }

        /// <summary>
        /// 返回或设置桌面歌词的渐变终止颜色
        /// </summary>
        [Description("返回或设置桌面歌词的渐变终止颜色")]
        public Color DesktopLyricTextColor1
        {
            get { return dtcolor1; }
            set
            {
                dtcolor1 = value;
                ResetSkin();
            }
        }

        /// <summary>
        /// 返回或设置桌面歌词的高亮渐变起始颜色
        /// </summary>
        [Description("返回或设置桌面歌词的高亮渐变起始颜色")]
        public Color DesktopLyricHighlightTextColor
        {
            get { return dhtcolor; }
            set
            {
                dhtcolor = value;
                ResetSkin();
            }
        }

        /// <summary>
        /// 返回或设置桌面歌词的高亮渐变终止颜色
        /// </summary>
        [Description("返回或设置桌面歌词的高亮渐变终止颜色")]
        public Color DesktopLyricHighlightTextColor1
        {
            get { return dhtcolor1; }
            set
            {
                dhtcolor1 = value;
                ResetSkin();
            }
        }

        /// <summary>
        /// 返回或设置桌面歌词的背景颜色
        /// </summary>
        [Description("返回或设置桌面歌词的背景颜色")]
        public Color DesktopLyricBackColor
        {
            get { return dbcolor; }
            set
            {
                dbcolor = value;
                ResetSkin();
            }
        }

        /// <summary>
        /// 返回或设置桌面歌词的边框颜色
        /// </summary>
        [Description("返回或设置桌面歌词的边框颜色")]
        public Color DesktopLyricBorderColor
        {
            get { return dbordercolor; }
            set
            {
                dbordercolor = value;
                ResetSkin();
            }
        }
        #endregion
        #region 方法
        /// <summary>
        /// 获取当前的歌词。
        /// </summary>
        [Browsable(false)]
        public Lyric CurrentLyric
        {
            get { return lyric; }
        }

        /// <summary>
        /// 获取或设置当前歌词的文件路径。
        /// </summary>
        public string LyricPath
        {
            get { return lpath; }
            set
            {
                lpath = value;
                current = 0;
                if (!System.IO.File.Exists(lpath))
                {
                    panel1.Controls.Clear();
                    return;
                }
                SetLyric(new Lyric(lpath));
            }
        }

        /// <summary>
        /// 获取或设置当前歌曲的播放进度。
        /// </summary>
        [Browsable(false)]
        public double CurrentProgress
        {
            get { return current; }
            set
            {
                current = value;
                this.Invalidate();
            }
        }

        /// <summary>
        /// 获取或设置桌面歌词的右键菜单。
        /// </summary>
        public ContextMenu DContextMenu
        {
            get { return fdl.ContextMenu; }
            set { fdl.ContextMenu = value; }
        }

        /// <summary>
        /// 设置与此LyricShow关联的歌词。
        /// </summary>
        /// <param name="l">需要设置的歌词。</param>
        public void SetLyric(Lyric l)
        {
            if (l == null) return;
            
            //清空原有歌词并重新初始化
            lyric = l;
            current = 0;
            panel1.Controls.Clear();

            //将每一行歌词作为控件添加至panel1中
            for (int i = 0; i < lyric.LyricTextLine.Length; i++)
            {
                string s = lyric.LyricTextLine[i];
                Label lb = new Label();
                lb.Text = s;
                lb.TextAlign = ContentAlignment.TopCenter;
                lb.Size = new Size(panel1.Width, this.Font.Height + 4);
                if (TextRenderer.MeasureText(s, this.Font).Width > (panel1.Width - 5) * 2) lb.Height *= 3;
                else if (TextRenderer.MeasureText(s, this.Font).Width > panel1.Width - 5) lb.Height = lb.Height * 2;
                lb.Location = new Point(0, panel1.Controls.Count != 0 ? panel1.Controls[panel1.Controls.Count - 1].Bottom + 5 : this.Height / 2 - lb.Height / 2);
                lb.Anchor = AnchorStyles.Left | AnchorStyles.Right | AnchorStyles.Top;
                panel1.Controls.Add(lb);
            }
            this.Invalidate();    //重绘歌词
        }

        /// <summary>
        /// 启用/取消桌面歌词的背景穿透功能。
        /// </summary>
        /// <returns>返回 bool 类型，表示是否启用了鼠标穿透功能。</returns>
        public bool Penetrate()
        {
            fdl.Penetrate();
            return fdl.trans;
        }

        /// <summary>
        /// 打开/关闭桌面歌词。
        /// </summary>
        /// <returns>返回 bool 类型，表示是否打开了桌面歌词。</returns>
        public bool OpenOrCloseDesktopLyric()
        {
            if (hid) fdl.Show();
            else fdl.Hide();
            hid = !hid;
            return hid;
        } 

        /// <summary>
        /// 重新配置歌词秀。
        /// </summary>
        public void ResetSkin()
        {
            fdl.BackColor = Color.FromArgb((int)(dbOpacity * 255), dbcolor);
            this.Invalidate();
            RefreshDesktopLyric();

            fdl.Font = dfont;
            fdl.Height = dfont.Height;
            fdl.Width = Screen.PrimaryScreen.Bounds.Width;
            fdl.border = dbordercolor;
            CustomDesktopLyric(fdl.cache);

            this.Invalidate();
        }

        /// <summary>
        /// 初始化并显示桌面歌词
        /// </summary>
        public void InitAndShowDesktopLyric()
        {
            fdl.Font = dfont;
            fdl.Width = Screen.PrimaryScreen.Bounds.Width;
            fdl.Height = (new Font("微软雅黑", 30, FontStyle.Bold)).Height;
            fdl.Left = 0;
            fdl.Top = Screen.PrimaryScreen.WorkingArea.Height - fdl.Height;
            fdl.Show();
            fdl.WindowState = FormWindowState.Normal;
        }

        /// <summary>
        /// 重置桌面歌词。
        /// </summary>
        public void ResetDesktopLyric()
        {
            fdl.SetBitmap(new Bitmap(1, 1));
        }

        /// <summary>
        /// 刷新桌面歌词。
        /// </summary>
        public void RefreshDesktopLyric()
        {
            double timecb = 0;
            for (int i = 0; i < panel1.Controls.Count; i++)
            {
                if (i != panel1.Controls.Count - 1)
                {
                    if (current >= GetNumberTime(lyric.LyricTimeLine[i]) && current < GetNumberTime(lyric.LyricTimeLine[i + 1]))
                    {
                        if (i != panel1.Controls.Count - 1)
                        {
                            double timec = GetNumberTime(lyric.LyricTimeLine[i + 1]) - GetNumberTime(lyric.LyricTimeLine[i]);
                            double timec1 = current - GetNumberTime(lyric.LyricTimeLine[i]);
                            timecb = timec1 / timec;
                        }
                        break;
                    }
                }
            }
            for (int i = 0; i < panel1.Controls.Count; i++)
            {
                if (i != panel1.Controls.Count - 1)
                {
                    if (current >= GetNumberTime(lyric.LyricTimeLine[i]) && current < GetNumberTime(lyric.LyricTimeLine[i + 1]))
                    {
                        Bitmap b = new Bitmap(fdl.Width, fdl.Height), b1 = new Bitmap(fdl.Width, fdl.Height);    //初始化进行绘制的位图
                        Graphics g = Graphics.FromImage(b), g1 = Graphics.FromImage(b1);                         //初始化Graphics
                        Size s = TextRenderer.MeasureText(panel1.Controls[i].Text, fdl.Font);                    //测量文本大小
                        Point offset = new Point(fdl.Width / 2 - s.Width / 2, 0);                                //位置偏移量，使歌词处于左右居中
                        int Opacity = (int)(dtOpacity * 255);                                                    //配置歌词的透明度

                        //检查文本大小及偏移量是否超出屏幕范围，如果是，则进行修改。
                        if (offset.X < 0) offset.X = 0;
                        if (s.Width > fdl.Width && ((int)(s.Width * timecb)) > fdl.Width) offset.X -= (((int)(s.Width * timecb)) - fdl.Width);
                        if (s.Width == 0) s.Width = 1; if (s.Height == 0) s.Height = 1;

                        //设置绘图方式
                        g.TextRenderingHint = System.Drawing.Text.TextRenderingHint.AntiAlias;
                        g1.TextRenderingHint = System.Drawing.Text.TextRenderingHint.AntiAlias;
                        g1.CompositingMode = CompositingMode.SourceCopy;

                        //绘制文本
                        g.DrawString(panel1.Controls[i].Text, fdl.Font,
                            new LinearGradientBrush(new Rectangle(offset, s),
                                Color.FromArgb(Opacity, dtcolor),
                                Color.FromArgb(Opacity, dtcolor1),
                                dAngle), offset);
                        g1.DrawString(panel1.Controls[i].Text, fdl.Font,
                            new LinearGradientBrush(new Rectangle(offset, s),
                                Color.FromArgb(Opacity, dhtcolor),
                                Color.FromArgb(Opacity, dhtcolor1),
                                dAngle), offset);

                        //绘制矩形并盖住文本以实现卡拉OK效果
                        g1.FillRectangle(Brushes.Transparent, offset.X + (int)(s.Width * timecb), 0, b1.Width, b1.Height);
                        g.DrawImage(b1, 0, 0);                                                                   //合并位图
                        b.MakeTransparent(Color.FromArgb(128, 127, 127, 127));                                   //透明处理
                        fdl.SetBitmap(b);                                                                        //显示至桌面歌词区域
                        break;
                    }
                }
            }
        }

        public void CustomDesktopLyric(string text)
        {
            //原理与RefreshLyric相同
            Size s = TextRenderer.MeasureText(text, fdl.Font);
            Point offset = new Point(fdl.Width / 2 - s.Width / 2, 0);
            Bitmap b = new Bitmap(fdl.Width, fdl.Height);
            Graphics g = Graphics.FromImage(b);
            int Opacity = (int)(dtOpacity * 255);
            if (s.Width == 0) s.Width = 1;
            if (s.Height == 0) s.Height = 1;
            g.TextRenderingHint = System.Drawing.Text.TextRenderingHint.AntiAlias;
            g.DrawString(text, fdl.Font,
                new LinearGradientBrush(new Rectangle(offset, s),
                    Color.FromArgb(Opacity, dtcolor),
                    Color.FromArgb(Opacity, dtcolor1),
                    dAngle), offset);
            fdl.SetBitmap(b);
            fdl.cache = text;
        }

        private double GetNumberTime(string s)
        {
            //将文本的时间转换为double
            //例如01:23.45将转换为83.45
            try
            {
                string[] ss = s.Split('.', ':');
                int t;
                t = int.Parse(ss[0]) * 60;
                t += int.Parse(ss[1]);
                return t + int.Parse(ss[2]) / 100.0;
            }
            catch { }
            return 0;
        }
        #endregion
        #region 事件
        protected override void OnPaint(PaintEventArgs e)
        {
            base.OnPaint(e);
            int temp = 0;                                //歌词绘制的高度偏移量
            e.Graphics.Clear(this.BackColor);            //用背景色填充

            for (int i = 0; i < panel1.Controls.Count; i++)
            {
                if (i != panel1.Controls.Count - 1)      //不处理最后一行歌词
                {
                    //如果当前播放进度在歌词行i和歌词行i+1之间，执行
                    if (current >= GetNumberTime(lyric.LyricTimeLine[i]) && current < GetNumberTime(lyric.LyricTimeLine[i + 1]))
                    {
                        int needy = panel1.Height / 2 - panel1.Controls[i].Height / 2;          //获取当前歌词需要显示的位置
                        temp = needy - panel1.Controls[i].Top;                                  //将当前偏移量移动至居中的位置

                        //微调偏移量以做到平滑移动
                        double timec = GetNumberTime(lyric.LyricTimeLine[i + 1]) - GetNumberTime(lyric.LyricTimeLine[i]);    //获取歌词行i和歌词行i+1的时间偏差量
                        double timec1 = current - GetNumberTime(lyric.LyricTimeLine[i]);        //获取当前播放进度已经超过了歌词行i的时间

                        //获取歌词行i和歌词行i+1的高度差距（根据控件的高度而进行微调）
                        double topc;
                        if (panel1.Controls[i + 1].Height == this.Font.Height + 4 && panel1.Controls[i].Height == (this.Font.Height + 4) * 2)
                            topc = panel1.Controls[i + 1].Top - panel1.Controls[i + 1].Height / 2 - panel1.Controls[i].Top;
                        else if (panel1.Controls[i + 1].Height == (this.Font.Height + 4) * 2 && panel1.Controls[i].Height == this.Font.Height + 4)
                            topc = panel1.Controls[i + 1].Top - panel1.Controls[i].Top + panel1.Controls[i].Height / 2 - 1;
                        else if (panel1.Controls[i + 1].Height == (this.Font.Height + 4) * 3 && panel1.Controls[i].Height == (this.Font.Height + 4) * 2)
                            topc = panel1.Controls[i + 1].Top - panel1.Controls[i].Top + (panel1.Controls[i + 1].Height / 2 - panel1.Controls[i].Height / 2);
                        else if (panel1.Controls[i + 1].Height == (this.Font.Height + 4) * 3 || panel1.Controls[i].Height == (this.Font.Height + 4) * 3)
                            topc = panel1.Controls[i + 1].Top - panel1.Controls[i].Top + (panel1.Controls[i + 1].Height / 2 - panel1.Controls[i].Height / 2);
                        else
                            topc = panel1.Controls[i + 1].Top - panel1.Controls[i].Top;

                        //修改偏移量
                        temp -= (int)(topc / timec * timec1);
                        break;
                    }
                }
            }
            for (int i = 0; i < panel1.Controls.Count; i++)
            {
                if (i != panel1.Controls.Count - 1)
                {
                    //绘制歌词
                    StringFormat sf = new StringFormat();
                    sf.Alignment = StringAlignment.Center;
                    sf.LineAlignment = StringAlignment.Center;
                    e.Graphics.TextRenderingHint = System.Drawing.Text.TextRenderingHint.AntiAliasGridFit;
                    if (current >= GetNumberTime(lyric.LyricTimeLine[i]) && current < GetNumberTime(lyric.LyricTimeLine[i + 1]))
                        e.Graphics.DrawString(panel1.Controls[i].Text, this.Font, new SolidBrush(lhtcolor), new Rectangle(5, 5 + temp + panel1.Controls[i].Top, panel1.Controls[i].Width, panel1.Controls[i].Height), sf);
                    else
                        e.Graphics.DrawString(panel1.Controls[i].Text, this.Font, new SolidBrush(ltcolor), new Rectangle(5, 5 + temp + panel1.Controls[i].Top, panel1.Controls[i].Width, panel1.Controls[i].Height), sf);
                }
            }
        }

        protected override void OnSizeChanged(EventArgs e)
        {
            base.OnSizeChanged(e);
            if (!this.DesignMode)
            {
                panel1.Width = this.Width - 10;
                panel1.Height = this.Height - 10;
                SetLyric(lyric);
            }
        }

        protected override void OnFontChanged(EventArgs e)
        {
            base.OnFontChanged(e);
            SetLyric(lyric);
        }
        #endregion
    }
}
