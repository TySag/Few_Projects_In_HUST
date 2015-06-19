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
    public partial class CheckBoxEX : UserControl
    {
        public CheckBoxEX()
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
        }

        private bool _Checked = false;
        private string _Text = "歌词";

        public bool Checked
        {
            get { return _Checked; }
            set
            {
                _Checked = value;
                this.Invalidate();
            }
        }

        public override string Text
        {
            get { return _Text; }
            set
            {
                _Text = value;
                this.Invalidate();
            }
        }

        protected override void OnPaint(PaintEventArgs e)
        {
            Graphics g = e.Graphics;
            using (Pen pen = new Pen(Brushes.White, 2))
            {
                //画方框
                g.DrawRectangle(pen, 2, 4, this.Height - 6, this.Height - 6);
                if (_Checked)
                {

                }
            }
            StringFormat sf = new StringFormat();
            sf.LineAlignment = StringAlignment.Center;
            sf.Alignment = StringAlignment.Near;
            Rectangle rectText = new Rectangle(this.Height, 3, this.Width - this.Height, this.Height-4);
            g.DrawString(_Text, new Font("黑体", 11), Brushes.White, rectText,sf);
            //base.OnPaint(e);
        }

    }
}
