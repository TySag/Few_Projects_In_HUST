using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Threading;

namespace MediaControlLibrary
{
    public partial class MediaContainer : Control
    {
        public MediaContainer()
        {
            InitializeComponent();
            #region style
            this.SetStyle(ControlStyles.ResizeRedraw, true);
            this.SetStyle(ControlStyles.OptimizedDoubleBuffer, true);
            this.SetStyle(ControlStyles.AllPaintingInWmPaint, true);
            this.SetStyle(ControlStyles.UserPaint, true);
            this.SetStyle(ControlStyles.SupportsTransparentBackColor, true);
            #endregion

            vScroll = new MediaVScroll(this);
            lists = new MediaListCollection(this);
            this.BackColor = Color.White;
            this.ForeColor = Color.Black;

            _mediaItemMouseOnColor = Color.FromArgb(0xe0, 0xee, 0xee);
            _mediaItemsSelectedColor = Color.FromArgb(0xb9, 0xd3, 0xee);
            _mediaItemPlayingColor = Color.FromArgb(0x9f, 0xb6, 0xcd);
        }

        #region 字段
        private MediaVScroll vScroll;
        private MediaItem bMouseOnMediaItem;
        private MediaList bMouseOnList;
        private bool bMouseEnterHead;
        private bool bMouseEnterTail;
        private bool bMouseEnterMenu;
        private bool bMouseShiftChoose;
        private bool bMouseCtrlChoose;
        private Point ptMousePos;
        #endregion

        #region 属性
        private MediaListCollection lists;
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Content)]
        [Browsable(true),Category("数据"),Description("列表项")]
        public MediaListCollection Lists
        {
            get
            {
                if (lists == null)
                    lists = new MediaListCollection(this);
                return lists;
            }
        }

        [DefaultValue(typeof(Color),"White")]
        [Browsable(true),Category("滚动条外观"),Description("滚动条背景色")]
        public Color VScrollBackColor
        {
            get
            {
                return vScroll.BackColor;
            }
            set
            {
                vScroll.BackColor = value;
            }
        }

        [DefaultValue(typeof(Color),"Gray")]
        [Browsable(true), Category("滚动条外观"), Description("滚动条滑块颜色")]
        public Color VScrollSliderColor
        {
            get
            {
                return vScroll.SliderColor;
            }
            set
            {
                vScroll.SliderColor = value;
            }
        }

        [DefaultValue(typeof(Color),"LightGray")]
        [Browsable(true), Category("滚动条外观"), Description("滚动条箭头颜色")]
        public Color VScrollArrowColor
        {
            get
            {
                return vScroll.ArrowColor;
            }
            set
            {
                vScroll.ArrowColor = value;
            }
        }

        [DefaultValue(typeof(Color),"DarkGray")]
        [Browsable(true), Category("滚动条外观"), Description("鼠标移入滚动条滑块时显示的颜色")]
        public Color VScrollSliderMouseOnColor
        {
            get
            {
                return vScroll.SliderMouseOnColor;
            }
            set
            {
                vScroll.SliderMouseOnColor = value;
            }
        }

        [DefaultValue(typeof(Color),"Black")]
        [Browsable(true), Category("滚动条外观"), Description("鼠标移入滚动条箭头时显示的颜色")]
        public Color VScrollArrowMouseOnColor
        {
            get
            {
                return vScroll.ArrowMouseOnColor;
            }
            set
            {
                vScroll.ArrowMouseOnColor = value;
            }
        }

        private Color _mediaItemBackColor;
        /// <summary>
        /// 媒体项背景色
        /// </summary>
        [DefaultValue(typeof(Color),"White")]
        [Browsable(true),Category("列表外观"),Description("媒体项背景色")]
        public Color MediaItemBackColor
        {
            get { return _mediaItemBackColor; }
            set
            {
                if (value == _mediaItemBackColor)
                    return;
                _mediaItemBackColor = value;
                this.Invalidate();
            }
        }

        private Color _mediaListBackColor;
        /// <summary>
        /// 列表项背景色
        /// </summary>
        [DefaultValue(typeof(Color),"White")]
        [Browsable(true),Category("列表外观"),Description("列表项背景色")]
        public Color MediaListBackColor
        {
            get { return _mediaListBackColor; }
            set
            {
                if (value == _mediaListBackColor)
                    return;
                _mediaListBackColor = value;
                this.Invalidate();
            }
        }


        private Color _mediaItemMouseOnColor;
        /// <summary>
        /// 鼠标移入媒体项时媒体项显示的背景色
        /// </summary>
        [Browsable(true),Category("列表外观"),Description("鼠标移入媒体项时媒体项显示的背景色")]
        public Color MediaItemMouseOnColor
        {
            get { return _mediaItemMouseOnColor; }
            set
            {
                if (value == _mediaItemMouseOnColor)
                    return;
                _mediaItemMouseOnColor = value;
            }
        }

        private Color _mediaListMouseOnColor;
        /// <summary>
        /// 鼠标移入列表项是列表项显示的背景色
        /// </summary>
        [DefaultValue(typeof(Color),"White")]
        [Browsable(true),Category("列表外观"),Description("鼠标移入列表项是列表项显示的背景色")]
        public Color MediaListMouseOnColor
        {
            get { return _mediaListMouseOnColor; }
            set
            {
                if (value == _mediaListMouseOnColor)
                    return;
                _mediaListMouseOnColor = value;
            }
        }

        private Color _mediaItemsSelectedColor;
        [Browsable(true),Category("列表外观"),Description("被选中的媒体项显示的背景色")]
        public Color MediaItemSelectedColor
        {
            get { return _mediaItemsSelectedColor; }
            set
            {
                if (value == _mediaItemsSelectedColor)
                    return;
                _mediaItemMouseOnColor = value;
            }
        }

        private Color _mediaItemPlayingColor;
        [Browsable(true),Category("列表外观"),Description("正在播放的媒体项显示的背景色")]
        public Color MediaItemPlayingColor
        {
            get { return _mediaItemPlayingColor; }
            set
            {
                if (_mediaItemPlayingColor == value)
                    return;
                _mediaItemPlayingColor = value;
            }
        }

        private Color _ListForeColor=Color.FromArgb(0x47,0x47,0x47);
        [Browsable(true),Category("列表外观"),Description("列表项前景色")]
        public Color ListForeColor
        {
            get { return _ListForeColor; }
            set { _ListForeColor = value; }
        }

        private Color _mediaItemForeColor=Color.FromArgb(0x75,0x75,0x75);
        [Browsable(true),Category("列表外观"),Description("媒体项前景色")]
        public Color MediaItemForeColor
        {
            get { return _mediaItemForeColor; }
            set { _mediaItemForeColor = value; }
        }

        private Font _listFont=new Font("宋体",10,FontStyle.Bold);
        [Browsable(true),Category("列表外观"),Description("列表项字体")]
        public Font ListFont
        {
            get { return _listFont; }
            set { _listFont = value; }
        }

        private Font _itemFont=new Font("宋体",10);
        [Browsable(true),Category("列表外观"),Description("媒体项字体")]
        public Font ItemFont
        {
            get { return _itemFont; }
            set { _itemFont = value; }
        }

        private List<MediaItem> _selectedMediaItems;
        /// <summary>
        /// 被选中的媒体项
        /// </summary>
        [Browsable(false)]
        public List<MediaItem> SelectedMediaItems
        {
            get { return _selectedMediaItems; }
        }

        private MediaItem _playingMediaItem;
        /// <summary>
        /// 正在播放的媒体项
        /// </summary>
        [Browsable(false)]
        public MediaItem PlayingMediaItem
        {
            get { return _playingMediaItem; }
            set { _playingMediaItem = value; }
        }

        [Browsable(false)]
        public bool ScrollDrawed
        {
            get { return vScroll.ShouldBeDraw; }
        }

        private bool _multiSelected;
        [Browsable(true),Category("行为"),Description("为true时使控件支持多选")]
        public bool MultiSelected
        {
            get { return _multiSelected; }
            set { _multiSelected = value; }
        }
        #endregion

        #region 事件
        public delegate void MediaEventHandler(object sender, MediaEventArgs e);
        public delegate void MediaListEventHandler(object sender, MediaListEventArgs e);
        public delegate void MediaItemEventHandler(object sender, MediaMouseEventArgs e);
        public delegate void MediaListMouseEventHandler(object sender, MediaListMouseEventArgs e);
        /// <summary>
        /// 鼠标单击媒体项
        /// </summary>
        [Browsable(true),Category("媒体项行为"),Description("鼠标单击媒体项")]
        public event MediaItemEventHandler ItemMouseClick;
        /// <summary>
        /// 鼠标单击列表项
        /// </summary>
        [Browsable(true),Category("列表项行为"),Description("鼠标单击列表项非Menu部分")]
        public event MediaListMouseEventHandler ListMouseClick;
        /// <summary>
        /// 鼠标停留于媒体项
        /// </summary>
        [Browsable(true), Category("媒体项行为"), Description("鼠标停留于媒体项")]
        public event MediaEventHandler ItemMouseHover;
        /// <summary>
        /// 鼠标单击列表项菜单按钮
        /// </summary>
        [Browsable(true), Category("列表项行为"), Description("鼠标单击列表项菜单按钮")]
        public event MediaListEventHandler ClickMenu;
        /// <summary>
        /// 鼠标进入列表项菜单按钮
        /// </summary>
        [Browsable(true), Category("列表项行为"), Description("鼠标进入列表项菜单按钮")]
        public event MediaListEventHandler MouseEnterMenu;
        /// <summary>
        /// 鼠标离开列表项菜单按钮
        /// </summary>
        [Browsable(true), Category("列表项行为"), Description("鼠标离开列表项菜单按钮")]
        public event MediaListEventHandler MouseLeaveMenu;
        /// <summary>
        /// 鼠标按下列表项菜单按钮
        /// </summary>
        [Browsable(true), Category("列表项行为"), Description("鼠标按下列表项菜单按钮")]
        public event MediaListEventHandler MouseDownMenu;
        /// <summary>
        /// 鼠标松开列表项菜单按钮
        /// </summary>
        [Browsable(true), Category("列表项行为"), Description("鼠标松开列表项菜单按钮")]
        public event MediaListEventHandler MouseUpMenu;
        /// <summary>
        /// 鼠标双击媒体项
        /// </summary>
        [Browsable(true), Category("媒体项行为"), Description("鼠标双击媒体项")]
        public event MediaEventHandler DoubleClickMediaItem;
        /// <summary>
        /// 鼠标进入媒体项头部按钮
        /// </summary>
        [Browsable(true), Category("媒体项行为"), Description("鼠标进入媒体项头部按钮")]
        public event MediaEventHandler MouseEnterHead;
        /// <summary>
        /// 鼠标离开媒体项头部按钮
        /// </summary>
        [Browsable(true), Category("媒体项行为"), Description("鼠标离开媒体项头部按钮")]
        public event MediaEventHandler MouseLeaveHead;
        /// <summary>
        /// 鼠标按下媒体项头部按钮
        /// </summary>
        [Browsable(true), Category("媒体项行为"), Description("鼠标按下媒体项头部按钮")]
        public event MediaEventHandler MouseDownHead;
        /// <summary>
        /// 鼠标松开媒体项头部按钮
        /// </summary>
        [Browsable(true), Category("媒体项行为"), Description("鼠标松开媒体项头部按钮")]
        public event MediaEventHandler MouseUpHead;
        /// <summary>
        /// 鼠标单击媒体项头部按钮
        /// </summary>
        [Browsable(true), Category("媒体项行为"), Description("鼠标单击媒体项头部按钮")]
        public event MediaEventHandler ClickHead;
        /// <summary>
        /// 鼠标进入媒体项尾部按钮
        /// </summary>
        [Browsable(true), Category("媒体项行为"), Description("鼠标进入媒体项尾部按钮")]
        public event MediaEventHandler MouseEnterTail;
        /// <summary>
        /// 鼠标离开媒体项尾部按钮
        /// </summary>
        [Browsable(true), Category("媒体项行为"), Description("鼠标离开媒体项尾部按钮")]
        public event MediaEventHandler MouseLeaveTail;
        /// <summary>
        /// 鼠标按下媒体项尾部按钮
        /// </summary>
        [Browsable(true), Category("媒体项行为"), Description("鼠标按下媒体项尾部按钮")]
        public event MediaEventHandler MouseDownTail;
        /// <summary>
        /// 鼠标松开媒体项尾部按钮
        /// </summary>
        [Browsable(true), Category("媒体项行为"), Description("鼠标松开媒体项尾部按钮")]
        public event MediaEventHandler MouseUpTail;
        /// <summary>
        /// 鼠标单击媒体项尾部按钮
        /// </summary>
        [Browsable(true), Category("媒体项行为"), Description("鼠标单击媒体项尾部按钮")]
        public event MediaEventHandler ClickTail;

        protected virtual void OnDoubleClickMediaItem(MediaEventArgs e)
        {
            if (DoubleClickMediaItem != null)
                DoubleClickMediaItem(this,e);
            _playingMediaItem = e.PlayingMediaItem;
            _playingMediaItem.IsPlaying = true;
        }

        protected override void OnCreateControl()
        {
            base.OnCreateControl();
        }

        protected virtual void OnMouseEnterHead(MediaEventArgs e)
        {
            if (MouseEnterHead != null)
                MouseEnterHead(this, e);
            if (!e.MouseOnMediaItem.IsPlaying)
            {
                e.MouseOnMediaItem.ClearMouseHead();
                e.MouseOnMediaItem.IsMouseOnHeadButton = true;
                this.Invalidate(e.MouseOnMediaItem.ClipBounds);
            }
        }

        protected virtual void OnMouseLeaveHead(MediaEventArgs e)
        {
            if (MouseLeaveHead != null)
                MouseLeaveHead(this, e);
            e.MouseOnMediaItem.ClearMouseHead();
            this.Invalidate(e.MouseOnMediaItem.ClipBounds);
        }

        protected virtual void OnMouseDownHead(MediaEventArgs e)
        {
            if (MouseDownHead != null)
                MouseDownHead(this, e);
            if (!e.MouseOnMediaItem.IsPlaying)
            {
                e.MouseOnMediaItem.ClearMouseHead();
                e.MouseOnMediaItem.IsMouseDownHeadbutton = true;
                this.Invalidate(e.MouseOnMediaItem.ClipBounds);
            }
        }

        protected virtual void OnMouseUpHead(MediaEventArgs e)
        {
            if (MouseUpHead != null)
                MouseUpHead(this, e);
            e.MouseOnMediaItem.ClearMouseHead();
            this.Invalidate(e.MouseOnMediaItem.ClipBounds);
        }

        protected virtual void OnClickHead(MediaEventArgs e)
        {
            if (ClickHead != null)
                ClickHead(this, e);
        }

        protected virtual void OnMouseEnterTail(MediaEventArgs e)
        {
            if (MouseEnterTail != null)
                MouseEnterTail(this, e);
            e.MouseOnMediaItem.ClearMouseTail();
            e.MouseOnMediaItem.IsMouseOnTail = true;
            this.Invalidate(e.MouseOnMediaItem.ClipBounds);
        }

        protected virtual void OnMouseLeaveTail(MediaEventArgs e)
        {
            if (MouseLeaveTail != null)
                MouseLeaveTail(this, e);
            e.MouseOnMediaItem.ClearMouseTail();
            this.Invalidate(e.MouseOnMediaItem.ClipBounds);
        }

        protected virtual void OnMouseDownTail(MediaEventArgs e)
        {
            if (MouseDownTail != null)
                MouseDownTail(this, e);
            e.MouseOnMediaItem.ClearMouseTail();
            e.MouseOnMediaItem.IsMouseDownTail = true;
            this.Invalidate(e.MouseOnMediaItem.ClipBounds);
        }

        protected virtual void OnMouseUpTail(MediaEventArgs e)
        {
            if (MouseUpTail != null)
                MouseUpTail(this, e);
            e.MouseOnMediaItem.ClearMouseTail();
            this.Invalidate(e.MouseOnMediaItem.ClipBounds);
        }

        protected virtual void OnClickTail(MediaEventArgs e)
        {
            if (ClickTail != null)
                ClickTail(this,e);
        }

        protected virtual void OnClickListMenu(MediaListEventArgs e)
        {
            if (ClickMenu != null)
                ClickMenu(this, e);
        }

        protected virtual void OnMouseEnterMenu(MediaListEventArgs e)
        {
            if (MouseEnterMenu != null)
                MouseEnterMenu(this, e);
            e.List.IsMouseOnMenu = true;
        }

        protected virtual void OnMouseLeaveMenu(MediaListEventArgs e)
        {
            if (MouseLeaveMenu != null)
                MouseLeaveMenu(this, e);
            e.List.IsMouseOnMenu = false;
        }

        protected virtual void OnMouseDownMenu(MediaListEventArgs e)
        {
            if (MouseDownMenu != null)
                MouseDownMenu(this, e);
            e.List.IsMouseDownMenu = true;
        }

        protected virtual void OnMouseUpMenu(MediaListEventArgs e)
        {
            if (MouseUpMenu != null)
                MouseUpMenu(this, e);
            e.List.IsMouseDownMenu = false;
        }

        protected virtual void OnItemMouseClick(MediaMouseEventArgs e)
        {
            if (ItemMouseClick != null)
                ItemMouseClick(this, e);
        }

        protected virtual void OnListMouseClick(MediaListMouseEventArgs e)
        {
            if (ListMouseClick != null)
                ListMouseClick(this, e);
        }

        protected virtual void OnItemMouseHover(MediaEventArgs e)
        {
            if (ItemMouseHover != null)
                ItemMouseHover(this, e);
        }
        #endregion

        #region 绘制
        /// <summary>
        /// 绘制列表项
        /// </summary>
        /// <param name="g">要绘制的表面</param>
        /// <param name="list">要绘制的列表项</param>
        /// <param name="rectList">列表项区域</param>
        /// <param name="brush">用到的画刷</param>
        protected virtual void DrawList(Graphics g, MediaList list, Rectangle rectList, SolidBrush brush)
        {
            StringFormat sf = new StringFormat();
            sf.LineAlignment = StringAlignment.Center;
            sf.SetTabStops(0.0f, new float[] { 30.0f });
            if (list.Equals(bMouseOnList))
                brush.Color = this._mediaListMouseOnColor;
            else
                brush.Color = this._mediaListBackColor;
            g.FillRectangle(brush, rectList);
            if (!list.IsOpen)
            {
                brush.Color = _ListForeColor;
                g.FillPolygon(brush, new Point[]{
                new Point(10,rectList.Top+8),
                new Point(10,rectList.Bottom-8),
                new Point(15,rectList.Top+rectList.Height/2)});
            }
            else
            {
                brush.Color = _ListForeColor;
                g.FillPolygon(brush, new Point[]{
                new Point(8,rectList.Top+12),
                new Point(rectList.Height-8,rectList.Top+12),
                new Point((rectList.Height-16)/2+8,rectList.Top+17)});
            }
            StringBuilder sb = new StringBuilder("\t");
            sb.Append(list.Title);
            sf.Alignment = StringAlignment.Near;
            g.DrawString(sb.ToString(), new Font("宋体", 10, FontStyle.Bold), brush, rectList, sf);
            brush.Color = Color.LightGray;
            float length = (g.MeasureString(sb.ToString(), _listFont)).Width;
            sf.SetTabStops(0.0f, new float[] { length - 20 });
            g.DrawString("\t[" + list.SubItems.Count + "]", new Font("宋体", 9), brush, rectList, sf);
            //绘制菜单按钮
            if (vScroll.ShouldBeDraw)
            {
                list.MenuBounds = new Rectangle(rectList.Right - 25 - list.Menu.Width, rectList.Top + 5,
                    list.Menu.Width, list.Menu.Height);
                g.DrawImage(list.Menu, list.MenuBounds);
            }
            else
            {
                list.MenuBounds = new Rectangle(rectList.Right - 25 - list.Menu.Width, rectList.Top + 5,
                   list.Menu.Width, list.Menu.Height);
                g.DrawImage(list.Menu, list.MenuBounds);
            }
        }

        /// <summary>
        /// 绘制媒体项
        /// </summary>
        /// <param name="g">要绘制的表面</param>
        /// <param name="item">要绘制的媒体项</param>
        /// <param name="rectItem">媒体项区域</param>
        /// <param name="brush">用到的画刷</param>
        protected virtual void DrawMediaItem(Graphics g, MediaItem item, Rectangle rectItem, SolidBrush brush)
        {
            if (item.Equals(_playingMediaItem))
            {
                brush.Color = this._mediaItemPlayingColor;
                g.FillRectangle(brush, rectItem);
                DrawPlayingMediaItem(g, item, rectItem);
                return;
            }
            if (item.Equals(bMouseOnMediaItem))
            {
                if (_selectedMediaItems != null && _selectedMediaItems.Contains(item))
                {
                    brush.Color = this._mediaItemsSelectedColor;
                    g.FillRectangle(brush, rectItem);
                    DrawMouseOnMediaItem(g, item, rectItem);
                    return;
                }
                if (!item.IsPlaying)
                {
                    brush.Color = this._mediaItemMouseOnColor;
                    g.FillRectangle(brush, rectItem);
                    DrawMouseOnMediaItem(g, item, rectItem);
                    return;
                }
            }
            if (_selectedMediaItems != null)
            {
                foreach (MediaItem nItem in _selectedMediaItems)
                {
                    if (item.Equals(nItem))
                    {
                        brush.Color = this._mediaItemsSelectedColor;
                        g.FillRectangle(brush, rectItem);
                        DrawNormalMediaItem(g, item, rectItem);
                        return;
                    }
                }
            }
            brush.Color = this._mediaItemBackColor;
            g.FillRectangle(brush, rectItem);
            DrawNormalMediaItem(g, item, rectItem);
        }

        /// <summary>
        /// 绘制普通媒体项（没有任何状态的媒体项）
        /// </summary>
        /// <param name="g">要绘制的表面</param>
        /// <param name="item">要绘制的媒体项</param>
        /// <param name="rectItem">要绘制的区域</param>
        private void DrawNormalMediaItem(Graphics g, MediaItem item, Rectangle rectItem)
        {
            StringFormat sf = new StringFormat();
            sf.Alignment = StringAlignment.Near;
            sf.SetTabStops(0.0f, new float[] { 28.0f });
            sf.LineAlignment = StringAlignment.Center;
            using (SolidBrush brush = new SolidBrush(_mediaItemForeColor))
            {
                StringBuilder sb = new StringBuilder(" ");
                sb.Append(item.Index.ToString("00"));
                sb.Append(" ");
                sb.Append(item.FirstContent);
                g.DrawString(sb.ToString(), _itemFont, brush, rectItem, sf);
                sf.Alignment = StringAlignment.Far;
                sf.SetTabStops(0.0f, new float[] { 25.0f });
                string tail = item.SecondContent + "\t";
                g.DrawString(tail, _itemFont, brush, rectItem, sf);
            }

        }

        /// <summary>
        /// 绘制鼠标移入时的媒体项
        /// </summary>
        /// <param name="g">要绘制的表面</param>
        /// <param name="item">要绘制的媒体项</param>
        /// <param name="rectItem">要绘制的区域</param>
        private void DrawMouseOnMediaItem(Graphics g, MediaItem item, Rectangle rectItem)
        {
            StringFormat sf = new StringFormat();
            sf.Alignment = StringAlignment.Near;
            sf.LineAlignment = StringAlignment.Center;
            float pos = g.MeasureString(" " + item.Index.ToString("00") + " ", _itemFont).Width;
            sf.SetTabStops(3.0f, new float[] { pos });
            g.DrawString("\t" + item.FirstContent, _itemFont, new SolidBrush(_mediaItemForeColor), 
                rectItem, sf);
            item.HeadRect = new Rectangle(rectItem.Left+2, rectItem.Top+2, item.HeadButton.Width,
                item.HeadButton.Height);
            g.DrawImage(item.HeadButton, item.HeadRect);
            item.TailRect = new Rectangle(rectItem.Right - 10 - item.TailButton.Width, rectItem.Top + 2,
                item.TailButton.Width, item.TailButton.Height);
            g.DrawImage(item.TailButton, item.TailRect);
            g.DrawRectangle(new Pen(Color.FromArgb(0x9a, 0xc0, 0xcd), 1), rectItem);
        }

        /// <summary>
        /// 绘制正在播放的媒体项
        /// </summary>
        /// <param name="g">要绘制的表面</param>
        /// <param name="item">要绘制的媒体项</param>
        /// <param name="rectItem">要绘制的区域</param>
        private void DrawPlayingMediaItem(Graphics g, MediaItem item, Rectangle rectItem)
        {
            item.HeadRect = new Rectangle(rectItem.Left + 2, rectItem.Top + 2, item.HeadImage.Width, 
                item.HeadImage.Height);
            StringFormat sf = new StringFormat();
            sf.Alignment = StringAlignment.Near;
            sf.LineAlignment = StringAlignment.Center;
            sf.SetTabStops(0.0f, new float[] { 2.0f + item.HeadRect.Width + 10 });
            Rectangle rectContent = new Rectangle(rectItem.X, rectItem.Y, rectItem.Width, rectItem.Height / 2);
            g.DrawString("\t" + item.FirstContent, _itemFont, new SolidBrush(Color.White), 
                rectContent, sf);
            rectContent.Y += rectItem.Height / 2;
            g.DrawString("\t" + item.SecondContent, _itemFont, new SolidBrush(Color.White), rectContent, sf);
            g.DrawImage(item.HeadImage, item.HeadRect);
            item.TailRect = new Rectangle(rectItem.Right - 10 - item.TailButton.Width, rectItem.Top + 2,
                item.TailButton.Width, item.TailButton.Height);
            g.DrawImage(item.TailButton, item.TailRect);
        }

        protected override void OnPaint(PaintEventArgs e)
        {
            SuspendLayout();

            Graphics g = e.Graphics;
            g.TranslateTransform(0, -vScroll.Value);
            SolidBrush brush = new SolidBrush(this._mediaListBackColor);
            Rectangle rectList = new Rectangle();
            Rectangle rectItem = new Rectangle();
            try
            {
                if (!vScroll.ShouldBeDraw)
                {
                    rectList.X = 0;
                    rectList.Y = 1;
                    rectList.Width = this.Width;
                    rectList.Height = 26;
                }
                else
                {
                    rectList.X = 0;
                    rectList.Y = 1;
                    rectList.Width = this.Width-12;
                    rectList.Height = 26;
                }
                for (int i = 0, countOfList = lists.Count; i < countOfList; i++)
                {
                    DrawList(g, lists[i], rectList, brush);
                    if (lists[i].IsOpen)
                    {
                        if (lists[i].SubItems.Count > 0)
                        {
                            rectItem.X = 20;
                            rectItem.Y = rectList.Y + rectList.Height;
                            rectItem.Width = rectList.Width - 20;
                            rectItem.Height = 25;
                            for (int j = 0, countOfItem = lists[i].SubItems.Count; j < countOfItem; j++)
                            {
                                if (lists[i].SubItems[j].IsPlaying)
                                {
                                    rectItem.Height = 4 + lists[i].SubItems[j].HeadImage.Height;
                                }
                                DrawMediaItem(g, lists[i].SubItems[j], rectItem, brush);
                                lists[i].SubItems[j].ClipBounds = new Rectangle(rectItem.Location, rectItem.Size);
                                rectItem.Y = rectItem.Bottom;
                                rectItem.Height = 25;
                            }
                            rectList.Height = rectItem.Bottom - rectList.Top - 26;
                        }
                    }
                    
                    lists[i].ClipBounds = new Rectangle(rectList.Location, rectList.Size);
                    g.DrawLine(new Pen(Color.LightGray, 1),
                        new Point(rectList.Left, rectList.Bottom + 1),
                        new Point(rectList.Right, rectList.Bottom + 1));
                    rectList.Y = rectList.Bottom + 1;
                    rectList.Height = 26;
                }
                g.ResetTransform();
                vScroll.ContentHeight = rectList.Bottom-26;
                if (vScroll.ShouldBeDraw)
                {
                    vScroll.ReDrawScroll(g);
                }
            }
            finally
            {
                brush.Dispose();
            }
            base.OnPaint(e);

            ResumeLayout();
        }
        #endregion

        #region 重写的事件
        protected override void OnMouseWheel(MouseEventArgs e)
        {
            if (e.Delta > 0)
                vScroll.Value -= 50;
            if (e.Delta < 0)
                vScroll.Value += 50; 
            this.OnMouseMove(e);
            base.OnMouseWheel(e);
        }
        
        protected override void OnMouseMove(MouseEventArgs e)
        {
            ptMousePos = e.Location;
            if (vScroll.IsDown)
            {
                vScroll.MoveSliderToLocation(e.Y);
                return;
            }
            if (vScroll.ShouldBeDraw)
            {
                if (vScroll.ClipBounds.Contains(e.Location))
                {
                    ClearItemMouseOn();
                    ClearListMouseOn();
                    if (vScroll.Slider.Contains(e.Location))
                        vScroll.IsMouseOnSlider = true;
                    else vScroll.IsMouseOnSlider = false;
                    if (vScroll.UpArrow.Contains(e.Location))
                        vScroll.IsMouseOnUp = true;
                    else vScroll.IsMouseOnUp = false;
                    if (vScroll.DownArrow.Contains(e.Location))
                        vScroll.IsMouseOnDown = true;
                    else vScroll.IsMouseOnDown = false;
                    return;
                }
                else
                    vScroll.ClearAllMouseOn();
            }
            ptMousePos.Y += vScroll.Value;
            for (int i = 0, countOfList = lists.Count; i < countOfList; i++)
            {
                if (lists[i].ClipBounds.Contains(ptMousePos))
                {
                    if (lists[i].IsOpen)
                    {
                        if (lists[i].SubItems.Count > 0)
                        {
                            for (int j = 0, countOfItem = lists[i].SubItems.Count; j < countOfItem; j++)
                            {
                                if (lists[i].SubItems[j].ClipBounds.Contains(ptMousePos))
                                {
                                    if (bMouseOnMediaItem != null)
                                    {
                                        if (lists[i].SubItems[j].HeadRect.Contains(ptMousePos))
                                        {
                                            if (!bMouseEnterHead)
                                            {
                                                OnMouseEnterHead(new MediaEventArgs(bMouseOnMediaItem, _playingMediaItem, _selectedMediaItems));
                                            }
                                            bMouseEnterHead = true;
                                        }
                                        else
                                        {
                                            if (bMouseEnterHead)
                                                OnMouseLeaveHead(new MediaEventArgs(bMouseOnMediaItem, _playingMediaItem, _selectedMediaItems));
                                            bMouseEnterHead = false;
                                        }
                                        if (lists[i].SubItems[j].TailRect.Contains(ptMousePos))
                                        {
                                            if (!bMouseEnterTail)
                                                OnMouseEnterTail(new MediaEventArgs(bMouseOnMediaItem, _playingMediaItem, _selectedMediaItems));
                                            bMouseEnterTail = true;
                                        }
                                        else
                                        {
                                            if (bMouseEnterTail)
                                                OnMouseLeaveTail(new MediaEventArgs(bMouseOnMediaItem, _playingMediaItem, _selectedMediaItems));
                                            bMouseEnterTail = false;
                                        }
                                    }
                                    if (lists[i].SubItems[j].Equals(bMouseOnMediaItem))
                                        return;
                                    ClearItemMouseOn();
                                    ClearListMouseOn();
                                    bMouseOnMediaItem = lists[i].SubItems[j];
                                    this.Invalidate(bMouseOnMediaItem.ClipBounds);
                                    return;
                                }
                                else
                                {
                                    if (bMouseEnterHead)
                                        OnMouseLeaveHead(new MediaEventArgs(bMouseOnMediaItem, _playingMediaItem, _selectedMediaItems));
                                    bMouseEnterHead = false;
                                    if (bMouseEnterTail)
                                        OnMouseLeaveTail(new MediaEventArgs(bMouseOnMediaItem, _playingMediaItem, _selectedMediaItems));
                                    bMouseEnterTail = false;
                                }
                            }
                            ClearListMouseOn();
                            bMouseOnList = lists[i];
                            if (lists[i].MenuBounds.Contains(e.Location))
                            {
                                if (!bMouseEnterMenu)
                                    OnMouseEnterMenu(new MediaListEventArgs(bMouseOnList));
                                bMouseEnterMenu = true;
                                lists[i].IsMouseOnMenu = true;
                            }
                            else
                            {
                                if (bMouseEnterMenu)
                                    OnMouseLeaveMenu(new MediaListEventArgs(bMouseOnList));
                                bMouseEnterMenu = false;
                            }
                            this.Invalidate(new Rectangle(bMouseOnList.ClipBounds.X, bMouseOnList.ClipBounds.Y,
                                bMouseOnList.ClipBounds.Width, 35));
                            return;
                        }
                        else
                        {
                            ClearListMouseOn();
                            bMouseOnList = lists[i];
                            if (lists[i].MenuBounds.Contains(e.Location))
                            {
                                if (!bMouseEnterMenu)
                                    OnMouseEnterMenu(new MediaListEventArgs(bMouseOnList));
                                bMouseEnterMenu = true;
                                lists[i].IsMouseOnMenu = true;
                            }
                            else
                            {
                                if (bMouseEnterMenu)
                                    OnMouseLeaveMenu(new MediaListEventArgs(bMouseOnList));
                                bMouseEnterMenu = false;
                            }
                            this.Invalidate(new Rectangle(bMouseOnList.ClipBounds.X, bMouseOnList.ClipBounds.Y,
                                bMouseOnList.ClipBounds.Width, 35));
                            return;
                        }
                    }
                    else
                    {
                        ClearListMouseOn();
                        ClearItemMouseOn();
                        bMouseOnList = lists[i];
                        if (lists[i].MenuBounds.Contains(e.Location))
                        {
                            if (!bMouseEnterMenu)
                                OnMouseEnterMenu(new MediaListEventArgs(bMouseOnList));
                            bMouseEnterMenu = true;
                        }
                        else
                        {
                            if (bMouseEnterMenu)
                                OnMouseLeaveMenu(new MediaListEventArgs(bMouseOnList));
                            bMouseEnterMenu = false;
                            lists[i].IsMouseOnMenu = false;
                        }
                        this.Invalidate(lists[i].ClipBounds);
                        return;
                    }
                }
            }
            ClearItemMouseOn();
            ClearListMouseOn();
            base.OnMouseMove(e);
        }
        
        protected override void OnMouseLeave(EventArgs e)
        {
            ClearItemMouseOn();
            ClearListMouseOn();
            vScroll.ClearAllMouseOn();
            base.OnMouseLeave(e);
        }

        protected override void OnMouseDoubleClick(MouseEventArgs e)
        {
            this.OnMouseClick(e);
            if (vScroll.ClipBounds.Contains(e.Location))
                return;
            Point pt = new Point(e.X, e.Y + vScroll.Value);
            for (int i = 0, countOfList = lists.Count; i < countOfList; i++)
            {
                if (lists[i].ClipBounds.Contains(pt))
                {
                    if (lists[i].IsOpen)
                    {
                        for (int j = 0, countOfItem = lists[i].SubItems.Count; j < countOfItem; j++)
                        {
                            if (lists[i].SubItems[j].ClipBounds.Contains(pt))
                            {
                                if (_playingMediaItem != null)
                                    _playingMediaItem.IsPlaying = false;
                                this._playingMediaItem = lists[i].SubItems[j];
                                _playingMediaItem.IsPlaying = true;
                                OnDoubleClickMediaItem(new MediaEventArgs(bMouseOnMediaItem, _playingMediaItem,
                                    _selectedMediaItems));
                                this.Invalidate();
                                return;
                            }
                        }
                    }
                }
            }
            base.OnMouseDoubleClick(e);
        }

        protected override void OnMouseDown(MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                if (vScroll.Slider.Contains(e.Location))
                {
                    vScroll.IsDown = true;
                    vScroll.MouseDownY = e.Y;
                }
                Point pt = new Point(e.X, e.Y + vScroll.Value);
                for (int i = 0, countOfList = lists.Count; i < countOfList; i++)
                {
                    if (lists[i].ClipBounds.Contains(pt))
                    {
                        if (lists[i].MenuBounds.Contains(pt))
                        {
                            OnMouseDownMenu(new MediaListEventArgs(bMouseOnList));
                            this.Invalidate();
                            return;
                        }
                        if (lists[i].SubItems.Count > 0)
                        {
                            for (int j = 0, countOfItem = lists[i].SubItems.Count; j < countOfItem; j++)
                            {
                                if (lists[i].SubItems[j].ClipBounds.Contains(pt))
                                {
                                    if (lists[i].SubItems[j].HeadRect.Contains(pt))
                                    {
                                        OnMouseDownHead(new MediaEventArgs(bMouseOnMediaItem, _playingMediaItem, _selectedMediaItems));
                                        this.Invalidate();
                                        return;
                                    }
                                    if (lists[i].SubItems[j].TailRect.Contains(pt))
                                    {
                                        OnMouseDownTail(new MediaEventArgs(bMouseOnMediaItem, _playingMediaItem, _selectedMediaItems));
                                        this.Invalidate();
                                        return;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            this.Focus();
            base.OnMouseDown(e);
        }

        protected override void OnMouseClick(MouseEventArgs e)
        {
            Point pos = new Point(e.X, e.Y + vScroll.Value);
            if (e.Button == MouseButtons.Left)
            {
                if (vScroll.IsDown)
                    return;
                if (vScroll.ClipBounds.Contains(e.Location) && vScroll.ShouldBeDraw)
                {
                    if (vScroll.Slider.Contains(e.Location))
                        return;
                    else if (vScroll.UpArrow.Contains(e.Location))
                        vScroll.Value -= 50;
                    else if (vScroll.DownArrow.Contains(e.Location))
                        vScroll.Value += 50;
                    else
                        vScroll.MoveSliderToLocation(e.Y);
                    return;
                }
                for (int i = 0, countOfList = lists.Count; i < countOfList; i++)
                {
                    if (lists[i].ClipBounds.Contains(pos))
                    {
                        if (lists[i].MenuBounds.Contains(pos))
                        {
                            OnClickListMenu(new MediaListEventArgs(lists[i]));
                            this.Invalidate();
                            return;
                        }
                        else
                        {
                            if (lists[i].IsOpen)
                            {
                                if (lists[i].SubItems.Count > 0)
                                {
                                    for (int j = 0, countOfItem = lists[i].SubItems.Count; j < countOfItem; j++)
                                    {
                                        if (lists[i].SubItems[j].ClipBounds.Contains(pos))
                                        {
                                            if (lists[i].SubItems[j].HeadRect.Contains(pos))
                                            {
                                                OnClickHead(new MediaEventArgs(bMouseOnMediaItem, _playingMediaItem, _selectedMediaItems));
                                            }
                                            else if (lists[i].SubItems[j].TailRect.Contains(e.Location))
                                            {
                                                OnClickHead(new MediaEventArgs(bMouseOnMediaItem, _playingMediaItem, _selectedMediaItems));
                                            }

                                            if (_selectedMediaItems == null)
                                                _selectedMediaItems = new List<MediaItem>();
                                            if (_multiSelected)
                                            {
                                                if (bMouseCtrlChoose)
                                                {
                                                    if (!_selectedMediaItems.Contains(lists[i].SubItems[j]))
                                                        _selectedMediaItems.Add(lists[i].SubItems[j]);
                                                    else
                                                        _selectedMediaItems.Remove(lists[i].SubItems[j]);
                                                    return;
                                                }
                                                if (bMouseShiftChoose)
                                                {
                                                    if (_selectedMediaItems.Count > 0)
                                                    {
                                                        int iX = Math.Min(_selectedMediaItems[0].Index, lists[i].SubItems[j].Index);
                                                        int last = Math.Max(_selectedMediaItems[0].Index, lists[i].SubItems[j].Index);
                                                        _selectedMediaItems.Clear();
                                                        for (; iX <= last; iX++)
                                                        {
                                                            _selectedMediaItems.Add(lists[i].SubItems[iX]);
                                                        }
                                                        return;
                                                    }
                                                }
                                                _selectedMediaItems.Clear();
                                                _selectedMediaItems.Add(lists[i].SubItems[j]);
                                                return;
                                            }
                                            else
                                            {
                                                _selectedMediaItems.Clear();
                                                _selectedMediaItems.Add(lists[i].SubItems[j]);
                                                return;
                                            }
                                        }
                                    }
                                }
                                lists[i].IsOpen = !lists[i].IsOpen;
                                this.Invalidate();
                                return;
                            }
                            else
                            {
                                _selectedMediaItems = null;
                                lists.CloseAllList();
                                lists[i].IsOpen = !lists[i].IsOpen;
                                this.Invalidate();
                                return;
                            }
                        }
                    }
                }
            }
            else if(e.Button==MouseButtons.Right)
            {
                for (int i = 0, countOfList = lists.Count; i < countOfList; i++)
                {
                    if (lists[i].ClipBounds.Contains(ptMousePos))
                    {
                        if (!lists[i].MenuBounds.Contains(ptMousePos))
                        {
                            if (lists[i].IsOpen)
                            {
                                for (int j = 0, countOfItem = lists[i].SubItems.Count; j < countOfItem; j++)
                                {
                                    if (!lists[i].SubItems[j].HeadRect.Contains(ptMousePos) && 
                                        !lists[i].SubItems[j].TailRect.Contains(ptMousePos))
                                    {//鼠标右击媒体项有效区域时激活事件
                                        OnItemMouseClick(new MediaMouseEventArgs(lists[i].SubItems[j], e));
                                    }
                                }
                            }
                            else
                            {//鼠标右击列表系i昂有效区域时激活事件
                                OnListMouseClick(new MediaListMouseEventArgs(lists[i], e));
                            }
                        }
                    }
                }
            }
            base.OnMouseClick(e);
        }

        protected override void OnMouseUp(MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                vScroll.IsDown = false;
                Point pt = new Point(e.X, e.Y + vScroll.Value);
                for (int i = 0, countOfList = lists.Count; i < countOfList; i++)
                {
                    if (lists[i].ClipBounds.Contains(pt))
                    {
                        if (lists[i].MenuBounds.Contains(pt))
                        {
                            OnMouseUpMenu(new MediaListEventArgs(bMouseOnList));
                            lists[i].IsMouseDownMenu = false;
                            this.Invalidate();
                            return;
                        }
                        if (lists[i].SubItems.Count > 0)
                        {
                            for (int j = 0, countOfItem = lists[i].SubItems.Count; j < countOfItem; j++)
                            {
                                if (lists[i].SubItems[j].ClipBounds.Contains(pt))
                                {
                                    if (lists[i].SubItems[j].HeadRect.Contains(pt))
                                    {
                                        OnMouseUpHead(new MediaEventArgs(bMouseOnMediaItem, _playingMediaItem, _selectedMediaItems));
                                        this.Invalidate();
                                        return;
                                    }
                                    if (lists[i].SubItems[j].TailRect.Contains(pt))
                                    {
                                        OnMouseUpTail(new MediaEventArgs(bMouseOnMediaItem, _playingMediaItem, _selectedMediaItems));
                                        this.Invalidate();
                                        return;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            base.OnMouseUp(e);
        }

        protected override void OnKeyDown(KeyEventArgs e)
        {
            if (_multiSelected)
            {
                if (e.Shift)
                {
                    bMouseShiftChoose = true;
                }
                else if (e.Control)
                {
                    bMouseCtrlChoose = true;
                }
            }
            base.OnKeyDown(e);
        }

        protected override void OnKeyUp(KeyEventArgs e)
        {
            if (_multiSelected)
            {
                if (e.KeyData==Keys.ShiftKey)
                {
                    bMouseShiftChoose = false;
                }
                else if (e.KeyData==Keys.ControlKey)
                {
                    bMouseCtrlChoose = false;
                }
                 
            }
            base.OnKeyUp(e);
        }

        protected override void OnKeyPress(KeyPressEventArgs e)
        {
            e.Handled = true;
            base.OnKeyPress(e);
        }

        protected override void OnMouseHover(EventArgs e)
        {
            //根据ptMousePos来激活相应的事件
            base.OnMouseHover(e);
        }
        #endregion

        private void ClearItemMouseOn()
        {
            if (bMouseOnMediaItem != null)
            {
                OnMouseLeaveHead(new MediaEventArgs(bMouseOnMediaItem, new EventArgs()));
                OnMouseLeaveTail(new MediaEventArgs(bMouseOnMediaItem, new EventArgs()));
                this.Invalidate(bMouseOnMediaItem.ClipBounds);
                bMouseOnMediaItem = null;
                bMouseEnterHead = false;
                bMouseEnterTail = false;
            }
        }

        private void ClearListMouseOn()
        {
            if (bMouseOnList != null)
            {
                OnMouseLeaveMenu(new MediaListEventArgs(bMouseOnList));
                this.Invalidate(bMouseOnList.ClipBounds);
                bMouseOnList = null;
                bMouseEnterMenu = false;
            }
        }

        public void FindItemByKey(string key)
        {
            for (int i = 0, countOfList = lists.Count; i < countOfList; i++)
            {
                if (lists[i].IsOpen)
                {
                    lists[i].FindItemByKey(key);
                    this.Invalidate();
                    return;
                }
            }
        }
    }

    public class MediaEventArgs
    {
        private MediaItem _mouseOnMediaItem;
        /// <summary>
        /// 鼠标移入的媒体项
        /// </summary>
        public MediaItem MouseOnMediaItem
        {
            get { return _mouseOnMediaItem; }
        }

        private List<MediaItem> _selectedMediaItems;
        /// <summary>
        /// 被选中的媒体项
        /// </summary>
        public List<MediaItem> SelectedMediaItems
        {
            get { return _selectedMediaItems; }
        }

        private MediaItem _playingMediaItem;
        /// <summary>
        /// 处于播放状态的媒体项
        /// </summary>
        public MediaItem PlayingMediaItem
        {
            get { return _playingMediaItem; }
        }

        private EventArgs _mouseEvent;
        public EventArgs MouseEvent
        {
            get { return _mouseEvent; }
        }

        public MediaEventArgs(MediaItem mouseOnMediaItem, MediaItem playingMediaItem, 
            List<MediaItem> selectedMediaItems)
        {
            this._mouseOnMediaItem = mouseOnMediaItem;
            this._playingMediaItem = playingMediaItem;
            this._selectedMediaItems = selectedMediaItems;
        }

        public MediaEventArgs(MediaItem mouseOnMediaItem,EventArgs mouseEvent)
        {
            this._mouseOnMediaItem = mouseOnMediaItem;
            this._mouseEvent = mouseEvent;
        }
    }

    public class MediaListEventArgs
    {
        private MediaList list=new MediaList();
        public MediaList List
        {
            get { return list; }
        }

        public MediaListEventArgs(MediaList list)
        {
            this.list = list;
        }
    }

    public class MediaMouseEventArgs
    {
        private MediaItem _currentItem;
        public MediaItem CurrentItem
        {
            get { return _currentItem; }
        }

        private MouseEventArgs _mouseEvent;
        public MouseEventArgs MouseEvent
        {
            get { return _mouseEvent; }
        }

        public MediaMouseEventArgs(MediaItem currentItem, MouseEventArgs mouseEvent)
        {
            this._currentItem = currentItem;
            this._mouseEvent = mouseEvent;
        }
    }

    public class MediaListMouseEventArgs
    {
        private MediaList _list;
        public MediaList List
        {
            get { return _list; }
        }

        private MouseEventArgs _mouseEvent;
        public MouseEventArgs MouseEvent
        {
            get { return _mouseEvent; }
        }

        public MediaListMouseEventArgs(MediaList list, MouseEventArgs mouseEvent)
        {
            this._list = list;
            this._mouseEvent = mouseEvent;
        }
    }
}
