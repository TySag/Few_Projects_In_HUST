using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Text;
using System.Windows.Forms;

using System.Drawing.Drawing2D;

namespace Tian.ButtonEx
{
    public partial class ButtonEx: PictureBox
    {
        public ButtonEx():base()
        {
            InitializeComponent();

            #region style
            this.SetStyle(ControlStyles.ResizeRedraw, true);
            this.SetStyle(ControlStyles.OptimizedDoubleBuffer, true);
            this.SetStyle(ControlStyles.AllPaintingInWmPaint, true);
            this.SetStyle(ControlStyles.UserPaint, true);
            this.SetStyle(ControlStyles.SupportsTransparentBackColor, true);
            #endregion

            this.BackColor = Color.Transparent;
            this.DoubleBuffered = true;
            this.Cursor = Cursors.Hand;
            
        }

        private enum buttonstate
        {
            Normal,
            Hover,
            Pressed
        }

        private buttonstate State = buttonstate.Normal;

        public enum buttonmode
        {
            PlayControl,
            FunctionBtuuon
        }

        #region 属性
        private buttonmode buttonMode = buttonmode.PlayControl;
        public buttonmode ButtonMode
        {
            get { return buttonMode; }
            set
            {
                if (buttonMode == value)
                {
                    return;
                }
                else
                {
                    buttonMode = value;
                    Invalidate();
                }
            }
        }

        #endregion

        protected override void OnPaint(PaintEventArgs pe)
        {
            if (Image == null)
            {
                return;
            }
            else
            {
                SuspendLayout();
                Graphics g = pe.Graphics;
                Bitmap ImgToDisplay = new Bitmap(Image);
                if (ButtonMode == buttonmode.PlayControl)
                {
                    if (State == buttonstate.Hover)
                    {
                        //环形；
                        GraphicsPath path = new GraphicsPath();
                        path.AddEllipse(0, 0, this.Width, this.Height);
                        //径向渐变刷
                        PathGradientBrush brush = new PathGradientBrush(path); //using System.Drawing.Drawing2D;
                        //中心颜色；
                        brush.CenterColor = Color.FromArgb(180, Color.White);
                        //边缘颜色；
                        brush.SurroundColors = new Color[] { Color.FromArgb(40, Color.White) };
                        g.FillPath(brush, path);
                    }
                    if (State == buttonstate.Pressed)
                    {
                        ImgToDisplay = DarkerImage((Bitmap)Image, 20);
                    }
                }
                else
                {
                    if (State == buttonstate.Normal)
                    {
                        ImgToDisplay = DarkerImage((Bitmap)Image, 30);
                    }
                    if (State == buttonstate.Pressed)
                    {
                        ImgToDisplay = DarkerImage((Bitmap)Image, 40);
                    }
                }

                if (ImgToDisplay != null)
                {
                    int x = 0;
                    int y = 0;
                    switch (SizeMode)
                    {
                        case PictureBoxSizeMode.AutoSize:
                            {
                                this.Size = ImgToDisplay.Size;
                                break;
                            }
                        case PictureBoxSizeMode.CenterImage:
                            {
                                x = (this.Width - ImgToDisplay.Width) / 2;
                                y = (this.Height - ImgToDisplay.Height) / 2;
                                break;
                            }
                        case PictureBoxSizeMode.Normal:
                            {
                                break;
                            }
                        case PictureBoxSizeMode.StretchImage:
                            {
                                ImgToDisplay = new Bitmap(ImgToDisplay, this.Size);
                                break;
                            }
                        case PictureBoxSizeMode.Zoom:
                            {
                                //图片的宽高比
                                double WtoH = (double)ImgToDisplay.Width / (double)ImgToDisplay.Height;

                                //图片框的宽高比
                                double wh = (double)this.Width / (double)this.Height;

                                if (WtoH >= wh)
                                {
                                    ImgToDisplay = new Bitmap(ImgToDisplay, this.Width, (int)(this.Width / WtoH));
                                    y = (this.Height - ImgToDisplay.Height) / 2;
                                }
                                else
                                {
                                    ImgToDisplay = new Bitmap(ImgToDisplay, (int)(this.Height * WtoH), this.Height);
                                    x = (this.Width - ImgToDisplay.Width) / 2;
                                }
                                break;
                            }
                        default:
                            break;
                    }
                    try
                    {
                        g.DrawImage(ImgToDisplay, x, y);
                    }
                    catch (Exception)
                    {
                        g.FillRegion(new SolidBrush(this.BackColor), this.Region);
                        //throw;
                    }
                }
            }
            ResumeLayout();
            //base.OnPaint(pe);
        }

        protected override void OnMouseEnter(EventArgs e)
		{
            State = buttonstate.Hover;
			this.Invalidate(false);
			base.OnMouseEnter (e);
		}

		protected override void OnMouseLeave(EventArgs e)
		{
            State = buttonstate.Normal;
            this.Invalidate(false);
			base.OnMouseLeave (e);
		}

        protected override void OnMouseDown(MouseEventArgs e)
        {
            State = buttonstate.Pressed;
            this.Invalidate(false);
            base.OnMouseDown(e);
        }

        protected override void OnMouseUp(MouseEventArgs e)
        {
            State = buttonstate.Hover;
            this.Invalidate(false);
            base.OnMouseUp(e);
        }

        /// <summary>
        /// 使图片变暗
        /// </summary>
        /// <param name="bmpSource">源图片</param>
        /// <param name="scale">变暗程度</param>
        /// <returns></returns>
        public Bitmap DarkerImage(Bitmap bmpSource,int scale)
        {
            Bitmap bmp = (Bitmap)bmpSource.Clone();
            for (int x = 0; x < bmp.Width; x++)
            {
                for (int y = 0; y < bmp.Height; y++)
                {
                    Color color = bmp.GetPixel(x, y);
                    int r = Math.Max(color.R - scale, 0);
                    int g = Math.Max(color.G - scale, 0);
                    int b = Math.Max(color.B - scale, 0);
                    color = Color.FromArgb(color.A, r, g, b);
                    bmp.SetPixel(x, y, color);
                }
            }
            return bmp;
        } 


    }
}
