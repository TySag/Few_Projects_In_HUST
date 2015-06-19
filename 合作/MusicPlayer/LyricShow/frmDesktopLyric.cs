using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;
using System.Windows.Forms;

namespace LyricShow
{
    public partial class frmDesktopLyric : Form
    {
        public frmDesktopLyric()
        {
            InitializeComponent();

            //将窗体设置为支持透明背景
            this.SetStyle(ControlStyles.SupportsTransparentBackColor, true);
        }

        bool enter = false; internal bool trans = false;     //鼠标是否已经移入歌词区域、鼠标穿透是否已经开启
        internal Bitmap oldbitmap = new Bitmap(1, 1);        //最后设置的位图
        internal string cache = "";                          //最后设置的文本
        internal Color border = Color.Black;                 //边框颜色

        #region 属性
        protected override CreateParams CreateParams
        {
            get
            {
                //重新定义窗体样式
                CreateParams cp = base.CreateParams;
                cp.ExStyle |= 0x00080000;
                return cp;
            }
        }
        #endregion
        #region 方法
        private void CanPenetrate()
        {
            //将窗体设置为鼠标可穿透
            uint intExTemp = Win32.GetWindowLong(this.Handle, Win32.GWL_EXSTYLE);
            uint oldGWLEx = Win32.SetWindowLong(this.Handle, Win32.GWL_EXSTYLE, Win32.WS_EX_TRANSPARENT | Win32.WS_EX_LAYERED);
            trans = true;
        }

        private void CancelPenetrate()
        {
            //将窗体设置为鼠标不可穿透
            Win32.SetWindowLong(this.Handle, Win32.GWL_EXSTYLE, Win32.WS_EX_LAYERED);
            trans = false;
        }

        internal void Penetrate()
        {
            //打开或关闭鼠标穿透
            if (trans) CancelPenetrate();
            else CanPenetrate();
        }

        internal void SetBitmap(Bitmap bitmap)
        {
            SetBitmap(bitmap, 255);
        }

        internal void SetBitmap(Bitmap bitmap, byte opacity)
        {
            //设置位图

            oldbitmap = bitmap;    //更新缓存
            if (enter)
            {
                //如果鼠标已经移入，重绘位图，在bitmat之后增加背景
                Bitmap b = new Bitmap(bitmap.Width, bitmap.Height);
                Graphics g = Graphics.FromImage(b);
                GraphicsPath roundedRect = new GraphicsPath();
                Rectangle rect = new Rectangle(0, 0, bitmap.Width - 1, bitmap.Height - 1);
                int cornerRadius = 5;
                g.SmoothingMode = SmoothingMode.AntiAlias;
                roundedRect.AddArc(rect.X, rect.Y, cornerRadius * 2, cornerRadius * 2, 180, 90);
                roundedRect.AddLine(rect.X + cornerRadius, rect.Y, rect.Right - cornerRadius * 2, rect.Y);
                roundedRect.AddArc(rect.X + rect.Width - cornerRadius * 2, rect.Y, cornerRadius * 2, cornerRadius * 2, 270, 90);
                roundedRect.AddLine(rect.Right, rect.Y + cornerRadius * 2, rect.Right, rect.Y + rect.Height - cornerRadius * 2);
                roundedRect.AddArc(rect.X + rect.Width - cornerRadius * 2, rect.Y + rect.Height - cornerRadius * 2, cornerRadius * 2, cornerRadius * 2, 0, 90);
                roundedRect.AddLine(rect.Right - cornerRadius * 2, rect.Bottom, rect.X + cornerRadius * 2, rect.Bottom);
                roundedRect.AddArc(rect.X, rect.Bottom - cornerRadius * 2, cornerRadius * 2, cornerRadius * 2, 90, 90);
                roundedRect.AddLine(rect.X, rect.Bottom - cornerRadius * 2, rect.X, rect.Y + cornerRadius * 2);
                roundedRect.CloseFigure();
                g.FillPath(new SolidBrush(this.BackColor), roundedRect);
                g.DrawPath(new Pen(Color.FromArgb(this.BackColor.A, border)), roundedRect);
                g.DrawImage(bitmap, 0, 0);
                bitmap = b;
            }

            //通过API设置图片
            IntPtr screenDc = Win32.GetDC(IntPtr.Zero);
            IntPtr memDc = Win32.CreateCompatibleDC(screenDc);
            IntPtr hBitmap = IntPtr.Zero;
            IntPtr oldBitmap = IntPtr.Zero;

            try
            {
                hBitmap = bitmap.GetHbitmap(Color.FromArgb(0));
                oldBitmap = Win32.SelectObject(memDc, hBitmap);

                Win32.Size size = new Win32.Size(bitmap.Width, bitmap.Height);
                Win32.Point pointSource = new Win32.Point(0, 0);
                Win32.Point topPos = new Win32.Point(Left, Top);
                Win32.BLENDFUNCTION blend = new Win32.BLENDFUNCTION();
                blend.BlendOp = Win32.AC_SRC_OVER;
                blend.BlendFlags = 0;
                blend.SourceConstantAlpha = opacity;
                blend.AlphaFormat = Win32.AC_SRC_ALPHA;

                Win32.UpdateLayeredWindow(Handle, screenDc, ref topPos, ref size, memDc, ref pointSource, 0, ref blend, Win32.ULW_ALPHA);
            }
            finally
            {
                Win32.ReleaseDC(IntPtr.Zero, screenDc);
                if (hBitmap != IntPtr.Zero)
                {
                    Win32.SelectObject(memDc, oldBitmap);
                    Win32.DeleteObject(hBitmap);
                }
                Win32.DeleteDC(memDc);
            }
        }
        #endregion
        #region 事件
        protected override void OnLocationChanged(EventArgs e)
        {
            //将窗体限制在屏幕工作区中
            if (this.Top > Screen.PrimaryScreen.WorkingArea.Bottom - this.Height) this.Top = Screen.PrimaryScreen.WorkingArea.Bottom - this.Height;
            if (this.Top < Screen.PrimaryScreen.WorkingArea.Top) this.Top = Screen.PrimaryScreen.WorkingArea.Top;
            base.OnLocationChanged(e);
        }

        private void frmDesktopLyric_MouseDown(object sender, MouseEventArgs e)
        {
            //是窗体允许拖动
            this.Capture = false;
            Message msg = Message.Create(Handle, Win32.WM_NCLBUTTONDOWN, (IntPtr)Win32.HT_CAPTION, IntPtr.Zero);
            WndProc(ref msg);    
        }

        private void frmDesktopLyric_MouseEnter(object sender, EventArgs e)
        {
            enter = true;
            SetBitmap(oldbitmap);
        }

        private void frmDesktopLyric_MouseLeave(object sender, EventArgs e)
        {
            enter = false;
            SetBitmap(oldbitmap);
        }

        protected override void OnSizeChanged(EventArgs e)
        {
            base.OnSizeChanged(e);
            //让窗体高度始终保持为肢体高度
            if (this.Height != this.Font.Height) this.Height = this.Font.Height;
        }
        #endregion
    }

    internal class Win32    //API函数类
    {
        public enum Bool
        {
            False = 0,
            True
        };

        [StructLayout(LayoutKind.Sequential)]
        public struct Point
        {
            public Int32 x;
            public Int32 y;

            public Point(Int32 x, Int32 y) { this.x = x; this.y = y; }
        }


        [StructLayout(LayoutKind.Sequential)]
        public struct Size
        {
            public Int32 cx;
            public Int32 cy;

            public Size(Int32 cx, Int32 cy) { this.cx = cx; this.cy = cy; }
        }


        [StructLayout(LayoutKind.Sequential, Pack = 1)]
        struct ARGB
        {
            public byte Blue;
            public byte Green;
            public byte Red;
            public byte Alpha;
        }


        [StructLayout(LayoutKind.Sequential, Pack = 1)]
        public struct BLENDFUNCTION
        {
            public byte BlendOp;
            public byte BlendFlags;
            public byte SourceConstantAlpha;
            public byte AlphaFormat;
        }

        public const int WM_NCLBUTTONDOWN = 0x00A1;
        public const int WM_NCHITTEST = 0x84;
        public const int HT_CAPTION = 0x2;
        public const int HT_CLIENT = 0x1;
        public const uint WS_EX_LAYERED = 0x80000;
        public const int WS_EX_TRANSPARENT = 0x20;
        public const int GWL_STYLE = (-16);
        public const int GWL_EXSTYLE = (-20);

        public const Int32 ULW_COLORKEY = 0x00000001;
        public const Int32 ULW_ALPHA = 0x00000002;
        public const Int32 ULW_OPAQUE = 0x00000004;

        public const byte AC_SRC_OVER = 0x00;
        public const byte AC_SRC_ALPHA = 0x01;

        [DllImport("user32", EntryPoint = "SetWindowLong")]
        public static extern uint SetWindowLong(IntPtr hwnd, int nIndex, uint dwNewLong);
        [DllImport("user32", EntryPoint = "GetWindowLong")]
        public static extern uint GetWindowLong(IntPtr hwnd, int nIndex);

        [DllImport("user32.dll", ExactSpelling = true, SetLastError = true)]
        public static extern Bool UpdateLayeredWindow(IntPtr hwnd, IntPtr hdcDst, ref Point pptDst, ref Size psize, IntPtr hdcSrc, ref Point pprSrc, Int32 crKey, ref BLENDFUNCTION pblend, Int32 dwFlags);

        [DllImport("user32.dll", ExactSpelling = true, SetLastError = true)]
        public static extern IntPtr GetDC(IntPtr hWnd);

        [DllImport("user32.dll", ExactSpelling = true)]
        public static extern int ReleaseDC(IntPtr hWnd, IntPtr hDC);

        [DllImport("gdi32.dll", ExactSpelling = true, SetLastError = true)]
        public static extern IntPtr CreateCompatibleDC(IntPtr hDC);

        [DllImport("gdi32.dll", ExactSpelling = true, SetLastError = true)]
        public static extern Bool DeleteDC(IntPtr hdc);

        [DllImport("gdi32.dll", ExactSpelling = true)]
        public static extern IntPtr SelectObject(IntPtr hDC, IntPtr hObject);

        [DllImport("gdi32.dll", ExactSpelling = true, SetLastError = true)]
        public static extern Bool DeleteObject(IntPtr hObject);
    }
}
