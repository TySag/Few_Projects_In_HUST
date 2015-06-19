using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Drawing.Drawing2D;

namespace MusicPlayer
{
    public partial class VolumeMark : UserControl
    {
        /// <summary>
        /// 音量标志控件
        /// </summary>
        public VolumeMark()
        {
            InitializeComponent();

            this.SetStyle(ControlStyles.SupportsTransparentBackColor, true);
            this.SetStyle(ControlStyles.ResizeRedraw, true);
            this.SetStyle(ControlStyles.OptimizedDoubleBuffer, true);
            this.SetStyle(ControlStyles.UserPaint, true);
            this.SetStyle(ControlStyles.AllPaintingInWmPaint, true);
            UpdateStyles();

            this.BackColor = Color.Transparent;
            this.Cursor = Cursors.Hand;
        }

        #region
        /// <summary>
        /// 当前音量
        /// </summary>
        private int _volume = 0;

        /// <summary>
        /// 是否静音
        /// </summary>
        private bool _isMuted = false;
        
        #endregion

        #region 属性
        [Description("音量值")]
        public int Volume
        {
            get { return _volume; }
            set
            {
                _volume = value;
                this.Invalidate();
            }
        }

        [Description("是否静音")]
        public bool IsMuted
        {
            get { return _isMuted; }
            set
            {
                _isMuted = value;
                this.Invalidate();
            }
        }

        #endregion

        protected override void OnPaint(PaintEventArgs e)
        {
            Graphics g = e.Graphics;
            //音量喇叭部分
            GraphicsPath speakerPath = new GraphicsPath();
            speakerPath.AddLine(0, this.Height * 5/16, this.Width / 5, this.Height * 5/16);
            speakerPath.AddLine(this.Width / 5, this.Height * 5/16, this.Width * 2 / 5, 0);
            speakerPath.AddLine(this.Width * 2 / 5, 0, this.Width * 2 / 5, this.Height);
            speakerPath.AddLine(this.Width * 2 / 5, this.Height, this.Width / 5, this.Height *11/16); ;
            speakerPath.AddLine(this.Width / 5, this.Height * 11/16, 0, this.Height *11/16);
            speakerPath.CloseAllFigures();
            g.FillPath(Brushes.White, speakerPath);

            if (_isMuted)
            {
                //如果静音则画叉
                using (Pen pen= new Pen(Brushes.White,2))
                {
                    g.DrawLine(pen, this.Width * 3 / 5, this.Height / 5, this.Width-3, this.Height * 4 / 5);
                    g.DrawLine(pen, this.Width * 3 / 5, this.Height*4 / 5, this.Width-3, this.Height / 5);
                }
            }
            else
            {
                 //如果音量不为0则画音量弧
                if (_volume>0&&_volume<40)
                {
                    using (Pen pen=new Pen(Brushes.White,2))
                    {
                        g.DrawArc(pen, this.Width * 5 / 10, this.Height*2 / 7, this.Width * 3 / 20, this.Height * 3 / 7, 270, 180);
                    }
                }
                else if (_volume>=40&&_volume<=100)
                {
                    using (Pen pen=new Pen(Brushes.White,2))
                    {
                        g.DrawArc(pen, this.Width * 5 / 10, this.Height * 2 / 7, this.Width * 3 / 20, this.Height * 3 / 7, 270, 180);
                        g.DrawArc(pen, this.Width * 7 / 10, this.Height / 7, this.Width * 2 / 10, this.Height * 5 / 7, 270, 180);
                    }
                }
            }

            //base.OnPaint(e);
        }

        protected override void OnMouseDown(MouseEventArgs e)
        {
            _isMuted = !_isMuted;
            this.Invalidate();
        }
    }
}
