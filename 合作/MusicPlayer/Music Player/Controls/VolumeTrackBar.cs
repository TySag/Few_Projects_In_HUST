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
    public partial class VolumeTrackBar : UserControl
    {
        public VolumeTrackBar()
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

        private int _Maximum = 100;
        [Description("最大值")]
        public int Maximum
        {
            get { return _Maximum; }
            set { _Maximum = value; }
        }

        private int _SmallChange = 1;
        [Description("响应鼠标滚轮滚动事件时的单次改变量")]
        public int SmallChange
        {
            get { return _SmallChange; }
            set { _SmallChange = value; }
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
            double percent = (double)Value / (double)Maximum;
            int X = LRMargins + (int)((double)Value / (double)this.Maximum  * (this.Width - LRMargins * 2));
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

            Rectangle rect1 = new Rectangle(rect.Left, rect.Top, (int)((double)Value / (double)this.Maximum * rect.Width), rect.Height);
            g.FillRectangle(new SolidBrush(Color.FromArgb(255, 255, 255, 255)), rect1);

            Rectangle rectV = new Rectangle(rect1.Right - (int)(0.5 * TrackHeight), (int)(this.Height / 2 - 1.25 * (double)TrackHeight), TrackHeight, (int)(2.5 * (double)TrackHeight));
            if (CState == ControlState.Pressed)
            {
                rectV.Inflate(1, 2);
                g.FillRectangle(Brushes.White, rectV);
            }
            else
            {
                g.FillRectangle(Brushes.White, rectV);
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
            this.Value = (int)(percent * Maximum );
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
                int valueTemp = (int)(percent * Maximum );
                if (valueTemp >= this.Maximum)
                {
                    this.Value = this.Maximum;
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

        /// <summary>
        /// 滚轮滚动
        /// </summary>
        /// <param name="e"></param>
        protected override void OnMouseWheel(MouseEventArgs e)
        {
            if ((CState == ControlState.Focused || CState == ControlState.Hover))
            {
                if (e.Delta > 0)
                {
                    if (this.Value + SmallChange >= this.Maximum)
                    {
                        this.Value = Maximum;
                    }
                    else
                    {
                        this.Value += SmallChange;
                    }
                }
                else
                {
                    if (this.Value - SmallChange <= 0)
                    {
                        this.Value = 0;
                    }
                    else
                    {
                        this.Value -= SmallChange;
                    }
                }

                if (ValueChanged != null)
                {
                    ValueChanged(this, e);
                }
            }

            //base.OnMouseWheel(e);
        }
        #endregion

        [Browsable(true)]
        public event EventHandler ValueChanged;
    }
}
