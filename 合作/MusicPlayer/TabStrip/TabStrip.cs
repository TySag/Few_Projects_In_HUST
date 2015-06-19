using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace TabStrip
{
    public partial class TabStrip : UserControl
    {
        public TabStrip()
        {
            InitializeComponent();

            this.SetStyle(ControlStyles.ResizeRedraw, true);
            this.SetStyle(ControlStyles.OptimizedDoubleBuffer, true);
            this.SetStyle(ControlStyles.AllPaintingInWmPaint, true);
            this.SetStyle(ControlStyles.UserPaint, true);
            this.SetStyle(ControlStyles.SupportsTransparentBackColor, true);

            this.AutoSize = false;
            this.BackColor = Color.Transparent;
        }

        private Font _Font;
        [Description("字体")]
        public Font Font
        {
            get { return _Font; }
            set
            {
                if (_Font == value)
                {
                    return;
                }
                else
                {
                    _Font = value;
                    Invalidate();
                }
            }
        }

        private Color _TextColorNormal;
        [Description("正常文字颜色")]
        public Color TextColorNormal
        {
            get { return _TextColorNormal; }
            set
            {
                if (_TextColorNormal == value)
                {
                    return;
                }
                else
                {
                    _TextColorNormal = value;
                    Invalidate();
                }
            }
        }

        private Color _TextColorSelected;
        [Description("被选中时文字颜色")]
        public Color TextColorSelected
        {
            get { return _TextColorSelected; }
            set
            {
                if (_TextColorSelected == value)
                {
                    return;
                }
                else
                {
                    _TextColorNormal = value;
                    Invalidate();
                }
            }
        }

        private int _TabHeight = 20;
        public int TabHeight
        {
            get { return _TabHeight; }
            set
            {
                _TabHeight = value;
                Invalidate();
            }
        }

        public void Add(string Title)
        {

        }

        public class TabItem
        {
            public string text;
            bool Selected;
        }

        public class TabItems
        {
            TabItem[] Items;
            int SelectedIndex;
            int Count;
        }

        protected override void OnPaint(PaintEventArgs e)
        {

            e.Graphics.FillRectangle(new SolidBrush(Color.FromArgb(40, 0, 0, 0)), this.ClientRectangle);
            e.Graphics.DrawLine(new Pen(Color.White, 0.5F), this.Width / 3, 3, this.Width / 3, this.Height - 6);
            e.Graphics.DrawLine(new Pen(Color.White, 0.5F), this.Width * 2 / 3, 3, this.Width * 2 / 3, this.Height - 6);
            //base.OnPaint(e);
        }

        //private void Add(string Text)
        //{

        //}

        protected override void OnMouseMove(MouseEventArgs e)
        {
            if (GetTabRectangle(0).Contains(e.Location))
            {
                Graphics g = CreateGraphics();
                g.FillRectangle(Brushes.Black, GetTabRectangle(0));
            }

            base.OnMouseMove(e);
        }

        private Rectangle GetTabRectangle(int index)
        {
            Rectangle rect = new Rectangle(0, 0, 50, 20);


            return rect;
        }
    }
}
