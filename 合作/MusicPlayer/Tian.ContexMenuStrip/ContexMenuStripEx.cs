using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Text;
using System.Windows.Forms;

using System.Drawing.Drawing2D;

namespace Tian.ContexMenuStripEx
{
    public partial class ContexMenuStripEx : ContextMenuStrip
    {
        public ContexMenuStripEx()
        {

            //this.SetStyle(ControlStyles.ResizeRedraw, true);
            //this.SetStyle(ControlStyles.OptimizedDoubleBuffer, true);
            //this.SetStyle(ControlStyles.AllPaintingInWmPaint, true);
            //this.SetStyle(ControlStyles.UserPaint, true);
            //this.SetStyle(ControlStyles.SupportsTransparentBackColor, true);
            //UpdateStyles();

            InitializeComponent();

            this.BackColor = Color.FromArgb(100, 255, 255, 255);
            SetRender();
            this.RenderMode = ToolStripRenderMode.Professional;
        }


        //子菜单项相关属性
        

        //背景相关属性
        public Color _seperatorColor = Color.DarkGray;
        public Color _arrawColor = Color.Black;

        #region 属性
        public Color _ItemSelectedColor = Color.Blue;
        [Description("菜单项被选中时的背景色"), Category("Appearance")]
        public Color ItemSelectedColor
        {
            get { return _ItemSelectedColor; }
            set
            {
                _ItemSelectedColor = value;
                SetRender();
            }
        }

        [Description("菜单分隔线色"), Category("Appearance")]
        public Color SeperatorColor
        {
            get { return _seperatorColor; }
            set
            {
                _seperatorColor = value;
                SetRender();
            }
        }

        [Description("箭头色"), Category("Appearance")]
        public Color ArrawColor
        {
            get { return _arrawColor; }
            set
            {
                _arrawColor = value;
                SetRender();
            }
        }
        #endregion


        //设置渲染器
        public void SetRender()
        {
            this.Renderer = new CustomRenderer(
                    _ItemSelectedColor,
                    this.BackColor,
                    _seperatorColor,
                    _arrawColor);
        }
    }

    /// <summary>
    /// 渲染器类
    /// </summary>
    public class CustomRenderer : ToolStripProfessionalRenderer
    {
        //子菜单项相关属性
        public Color _ItemSelectedColor = Color.Blue;

        //下拉菜单背景相关属性
        public Color _BackColor = Color.FromArgb(200, Color.White);
        public Color _seperatorColor = Color.DarkGray;
        public Color _arrawColor = Color.Black;

        #region 构造函数
        //默认构造函数
        public CustomRenderer()
            : base()
        {
        }

        //带参数构造函数
        public CustomRenderer(
            Color ItemSelectedCorlor,
            Color BackColor,
            Color SeperatorColor,
            Color ArrowColor)
            : base()
        {
            _ItemSelectedColor = ItemSelectedCorlor;
            _BackColor = BackColor;
            _seperatorColor = SeperatorColor;
            _arrawColor = ArrowColor;
        }
        #endregion

        //渲染背景
        protected override void OnRenderToolStripBackground(ToolStripRenderEventArgs e)
        {
            ToolStrip toolStrip = e.ToolStrip;
            Graphics g = e.Graphics;
            g.SmoothingMode = SmoothingMode.HighQuality;//抗锯齿
            Rectangle bounds = e.AffectedBounds;

            using (SolidBrush sdbrush = new SolidBrush(_BackColor))
                g.FillRectangle(sdbrush, bounds);
        }

        //渲染边框 不绘制边框
        protected override void OnRenderToolStripBorder(ToolStripRenderEventArgs e)
        {
            //base.OnRenderToolStripBorder(e);
            //不调用基类的方法 屏蔽掉该方法 去掉边框
        }

        //渲染箭头 更改箭头颜色
        protected override void OnRenderArrow(ToolStripArrowRenderEventArgs e)
        {
            e.ArrowColor = _arrawColor; ;
            base.OnRenderArrow(e);
        }

        //渲染项 不调用基类同名方法
        protected override void OnRenderMenuItemBackground(ToolStripItemRenderEventArgs e)
        {
            Graphics g = e.Graphics;
            ToolStripItem item = e.Item;
            ToolStrip toolstrip = e.ToolStrip;

            //渲染菜单项
            if (e.Item.Selected || e.Item.Pressed)
            {
                using (SolidBrush sdbrush = new SolidBrush(Color.SkyBlue))
                    g.FillRectangle(sdbrush, item.ContentRectangle);
            }
        }

        //渲染分界线
        protected override void OnRenderSeparator(ToolStripSeparatorRenderEventArgs e)
        {
            using (SolidBrush sdBrush = new SolidBrush(_seperatorColor))
                e.Graphics.FillRectangle(sdBrush, new Rectangle(5, e.Item.Height / 2, e.Item.Width - 10, 1));
            //base.OnRenderSeparator(e);
        }

        //渲染图片区域 下拉菜单左边的图片区域
        protected override void OnRenderImageMargin(ToolStripRenderEventArgs e)
        {
            //base.OnRenderImageMargin(e);
            //屏蔽掉左边图片竖条
        }
    }

}

