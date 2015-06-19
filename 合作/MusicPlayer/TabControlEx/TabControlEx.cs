using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Drawing.Drawing2D;

namespace TabControlEx
{
    public partial class TabControlEx: TabControl
    {
        public TabControlEx()
        {
            base.SetStyle(
                     ControlStyles.UserPaint |                      // 控件将自行绘制，而不是通过操作系统来绘制
                     ControlStyles.OptimizedDoubleBuffer |          // 该控件首先在缓冲区中绘制，而不是直接绘制到屏幕上，这样可以减少闪烁
                     ControlStyles.AllPaintingInWmPaint |           // 控件将忽略 WM_ERASEBKGND 窗口消息以减少闪烁
                     ControlStyles.ResizeRedraw |                   // 在调整控件大小时重绘控件
                     ControlStyles.SupportsTransparentBackColor,    // 控件接受 alpha 组件小于 255 的 BackColor 以模拟透明
                     true);                                         // 设置以上值为 true
            base.UpdateStyles();

            

            InitializeComponent();           
            this.SizeMode = TabSizeMode.Fixed;
            this.ItemSize = new Size(TabWidth, 30);
            this.DrawMode = TabDrawMode.OwnerDrawFixed;

            this.HotTrack = true;

        }

        private int _TabWidth=30;
        public int TabWidth
        {
            get{return _TabWidth;}
            set
            {
                if (_TabWidth == value)
                {
                    return;
                }
                else
                {
                    _TabWidth = value;
                    Invalidate();
                }
            }
        }

        protected override void OnPaint(PaintEventArgs e)
        {
            SuspendLayout();
            Graphics g = e.Graphics;

            for (int i = 0; i < TabCount; i++)
            {
                if (this.SelectedIndex == i)
                {
                    g.FillRectangle(Brushes.Red, GetTabRect(i));
                }
            }

            if (this.Width > 0 && this.Height > 0)
            {
                //	Cached Background Image
                Bitmap bmp = new Bitmap(this.Width, this.Height);
                Graphics backGraphics = Graphics.FromImage(bmp);
                backGraphics.Clear(Color.Transparent);
                this.PaintTransparentBackground(backGraphics, this.ClientRectangle);
            }


            ResumeLayout();
            //base.OnPaint(e);
        }

        protected override void OnMouseMove(MouseEventArgs e)
        {
            Graphics g = CreateGraphics();
            if (this.HotTrack)
            {
                int index = GetIndexWithPoint(e.Location);
                if (index >= 0)
                {
                    g.FillRectangle(Brushes.Blue, GetTabRect(index));

                }

            }

            //base.OnMouseMove(e);
        }

        private int GetIndexWithPoint(Point Pt)
        {
            for (int i = 0; i < TabCount; i++)
            {
                if (GetTabRect(i).Contains(Pt))
                {
                    return i;
                }
            }
            return -1;
        }

        protected override void OnSizeChanged(EventArgs e)
        {

            //base.OnSizeChanged(e);
        }

        protected override void OnPaintBackground(PaintEventArgs pevent)
        {
            //pevent.Graphics.FillRectangle(new SolidBrush(Color.Transparent), this.ClientRectangle);
            base.OnPaintBackground(pevent);
        }

        protected void PaintTransparentBackground(Graphics graphics, Rectangle clipRect)
        {
            if ((this.Parent != null))
            {
                //	Set the cliprect to be relative to the parent
                clipRect.Offset(this.Location);

                //	Save the current state before we do anything.
                GraphicsState state = graphics.Save();

                //	Set the graphicsobject to be relative to the parent
                graphics.TranslateTransform((float)-this.Location.X, (float)-this.Location.Y);
                graphics.SmoothingMode = SmoothingMode.HighSpeed;

                //	Paint the parent
                PaintEventArgs e = new PaintEventArgs(graphics, clipRect);
                try
                {
                    this.InvokePaintBackground(this.Parent, e);
                    this.InvokePaint(this.Parent, e);
                }
                finally
                {
                    //	Restore the graphics state and the clipRect to their original locations
                    graphics.Restore(state);
                    clipRect.Offset(-this.Location.X, -this.Location.Y);
                }
            }
        }


    }
}
