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
    /// <summary>
    /// 播放进度条控件
    /// </summary>
    public partial class PlayingTrackBar : UserControl
    {
        public PlayingTrackBar()
        {
            InitializeComponent();

            this.SetStyle(ControlStyles.ResizeRedraw, true);
            this.SetStyle(ControlStyles.OptimizedDoubleBuffer, true);
            this.SetStyle(ControlStyles.AllPaintingInWmPaint, true);
            this.SetStyle(ControlStyles.UserPaint, true);
            this.SetStyle(ControlStyles.SupportsTransparentBackColor, true);
            UpdateStyles();

            this.BackColor = Color.Transparent;
            this.Cursor = Cursors.Hand;
            this.AutoSize = false;
        }

        #region 属性
        private int _Value = 0;
        [Description("当前值")]
        public int Value
        {
            get { return _Value; }
            set
            {
                if (_Value == value)
                {
                    return;
                }
                else
                {
                    _Value = value;
                    this.Invalidate();
                    if (ValueChanged != null)
                    {
                        ValueChanged(this, new EventArgs());
                    }
                }
            }
        }

        /// <summary>
        /// 对应的总时间
        /// </summary>
        private int _TotalTime = 100;
        [Description("最大值")]
        public int TotalTime
        {
            get { return _TotalTime; }
            set { _TotalTime = value; }
        }

        private int _TrackHeight = 10;
        [Description("滑道高度")]
        public int TrackHeight
        {
            get { return _TrackHeight; }
            set
            {
                _TrackHeight = value;
                this.Invalidate();
            }
        }

        private int _LRMargins = 10;
        [Description("滑道左右空出的边距，防止圆形滑块在两端显示不全")]
        public int LRMargins
        {
            get { return _LRMargins; }
            set
            {
                _LRMargins = value;
                this.Invalidate();
            }
        }

        #endregion

        /// <summary>
        /// 控件的状态。
        /// </summary>
        public enum ControlState
        {
            /// <summary>
            ///  正常。
            /// </summary>
            Normal,
            /// <summary>
            /// 鼠标进入。
            /// </summary>
            Hover,
            /// <summary>
            /// 鼠标按下。
            /// </summary>
            Pressed,
            /// <summary>
            /// 获得焦点。
            /// </summary>
            Focused,
        }

        /// <summary>
        /// 根据当前Value得到图形滑块轮廓
        /// </summary>
        /// <param name="CurrentValue">当前值</param>
        /// <param name="radius">圆形滑块半径</param>
        /// <returns></returns>
        public GraphicsPath CreateRoundPath(int CurrentValue, int radius)
        {
            double percent = (double)Value / (double)(TotalTime);
            int X = LRMargins + (int)((double)Value / (double)(this.TotalTime ) * (this.Width - LRMargins * 2));
            GraphicsPath gp = new GraphicsPath();
            gp.AddEllipse(X - radius, this.Height / 2 - radius, radius * 2, radius * 2);
            gp.CloseFigure();
            return gp;
        }

        /// <summary>
        /// 绘制
        /// </summary>
        /// <param name="e"></param>
        protected override void OnPaint(PaintEventArgs e)
        {
            Graphics g = e.Graphics;

            Rectangle rect = new Rectangle(LRMargins, (this.Height - TrackHeight) / 2, this.Width - LRMargins * 2, TrackHeight);
            g.FillRectangle(new SolidBrush(Color.FromArgb(80, 0, 0, 0)), rect);

            Rectangle rect1 = new Rectangle(rect.Left, rect.Top, (int)((double)Value / (double)this.TotalTime * rect.Width), rect.Height);
            g.FillRectangle(new SolidBrush(Color.FromArgb(255, 255, 255, 255)), rect1);

            //作为播放进度条，控制钮为圆形
            if (CState == ControlState.Normal || CState == ControlState.Focused)
            {
                g.FillPath(Brushes.White, CreateRoundPath(Value, TrackHeight));
            }
            if (CState == ControlState.Hover)
            {
                GraphicsPath gp = CreateRoundPath(Value, 2 * this.TrackHeight);
                g.FillPath(new SolidBrush(Color.FromArgb(150, 255, 255, 255)), gp);
                g.FillPath(Brushes.White, CreateRoundPath(Value, this.TrackHeight));
            }
            if (CState == ControlState.Pressed)
            {
                GraphicsPath gp = CreateRoundPath(Value, 2 * this.TrackHeight);
                g.FillPath(new SolidBrush(Color.FromArgb(100, 255, 255, 255)), gp);
                g.DrawPath(new Pen(Color.FromArgb(230, 255, 255, 255), 2), gp);
                g.FillPath(Brushes.White, CreateRoundPath(Value, this.TrackHeight));
            }
            base.OnPaint(e);
        }

        /// <summary>
        /// 鼠标在控件中的状态
        /// </summary>
        public ControlState CState = ControlState.Normal;

        #region 重写事件

        /// <summary>
        /// 鼠标按下事件
        /// </summary>
        /// <param name="e"></param>
        protected override void OnMouseDown(MouseEventArgs e)
        {
            CState = ControlState.Pressed;
            double percent = (double)(e.X - LRMargins) / (double)(this.Width - LRMargins * 2);
            this.Value = (int)(percent * TotalTime);
            Invalidate();
            if (ValueChanged != null)
            {
                ValueChanged(this, e);
            }
            base.OnMouseDown(e);
        }

        /// <summary>
        /// 鼠标释放事件
        /// </summary>
        /// <param name="e"></param>
        protected override void OnMouseUp(MouseEventArgs e)
        {
            CState = ControlState.Normal;
            Invalidate();
            base.OnMouseUp(e);
        }

        /// <summary>
        /// 鼠标移动事件
        /// </summary>
        /// <param name="e"></param>
        protected override void OnMouseMove(MouseEventArgs e)
        {
            GraphicsPath gp = CreateRoundPath(Value, TrackHeight);
            if (gp.GetBounds().Contains(e.Location) && CState != ControlState.Pressed)
            {
                CState = ControlState.Hover;
                Invalidate();
            }
            else if (!gp.GetBounds().Contains(e.Location) && CState != ControlState.Pressed)
            {
                CState = ControlState.Focused;
                Invalidate();
            }

            if (CState == ControlState.Pressed && this.Focused)
            {
                double percent = (double)(e.X - LRMargins) / (double)(this.Width - LRMargins * 2);
                int valueTemp = (int)(percent * TotalTime);
                if (valueTemp >= this.TotalTime)
                {
                    this.Value = this.TotalTime;
                }
                else if (valueTemp <= 0)
                {
                    this.Value = 0;
                }
                else
                {
                    this.Value = valueTemp;
                }
                Invalidate();

                if (ValueChanged != null)
                {
                    ValueChanged(this, e);
                }
            }
            base.OnMouseMove(e);
        }

        /// <summary>
        /// 鼠标进入
        /// </summary>
        /// <param name="e"></param>
        protected override void OnMouseEnter(EventArgs e)
        {
            this.Focus();
            CState = ControlState.Focused;
            //base.OnMouseEnter(e);
        }

        /// <summary>
        /// 鼠标离开
        /// </summary>
        /// <param name="e"></param>
        protected override void OnMouseLeave(EventArgs e)
        {
            this.Parent.Focus();
            CState = ControlState.Normal;
            //base.OnMouseLeave(e);
        }

        [Description("值改变事件"), Browsable(true)]
        public event EventHandler ValueChanged;
        
        #endregion

    }
}
