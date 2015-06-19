using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Text;
using System.Windows.Forms;
using System.Collections;
using System.Threading;

namespace PlaylistBox
{
    public partial class PlayListBox : Control
    {
        /// <summary>
        /// 播放列表控件
        /// </summary>
        public PlayListBox()
        {
            InitializeComponent();
            
            this.Size = new Size(150, 250);
            this.items = new PlayListItemCollection(this);
            VScroll = new PlayListVScroll(this);

            this.BackColor = Color.White;
            this.ForeColor = Color.Black;
            this.itemColor = Color.White;
            this.subItemColor = Color.White;
            this.itemMouseOnColor = Color.LightBlue;
            this.subItemMouseOnColor = Color.LightBlue;
            this.subItemSelectColor = Color.LightBlue;
            this.arrowColor = Color.Black;

            this.SetStyle(ControlStyles.ResizeRedraw, true);
            this.SetStyle(ControlStyles.OptimizedDoubleBuffer, true);
            this.SetStyle(ControlStyles.AllPaintingInWmPaint, true);
            this.SetStyle(ControlStyles.UserPaint, true);
            this.SetStyle(ControlStyles.SupportsTransparentBackColor, true);
        }

        #region 属性

        private PlayListItemCollection items;
        /// <summary>
        /// 获取列表中所有列表项的集合
        /// </summary>
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Content)]
        public PlayListItemCollection Items
        {
            get
            {
                if (items == null)
                    items = new PlayListItemCollection(this);
                return items;
            }
        }

        private SongItem selectSubItem;
        /// <summary>
        /// 当前选中的子项
        /// </summary>
        [Browsable(false)]
        public SongItem SelectSubItem
        {
            get { return selectSubItem; }
        }

        /// <summary>
        /// 获取或者设置滚动条背景色
        /// </summary>
        [DefaultValue(typeof(Color), "LightYellow"), Category("ControlColor")]
        [Description("滚动条的背景颜色")]
        public Color ScrollBackColor
        {
            get { return VScroll.BackColor; }
            set { VScroll.BackColor = value; }
        }

        /// <summary>
        /// 获取或者设置滚动条滑块默认颜色
        /// </summary>
        [DefaultValue(typeof(Color), "Gray"), Category("ControlColor")]
        [Description("滚动条滑块默认情况下的颜色")]
        public Color ScrollSliderDefaultColor
        {
            get { return VScroll.SliderDefaultColor; }
            set { VScroll.SliderDefaultColor = value; }
        }
        /// <summary>
        /// 获取或者设置滚动条点下的颜色
        /// </summary>
        [DefaultValue(typeof(Color), "DarkGray"), Category("ControlColor")]
        [Description("滚动条滑块被点击或者鼠标移动到上面时候的颜色")]
        public Color ScrollSliderDownColor
        {
            get { return VScroll.SliderDownColor; }
            set { VScroll.SliderDownColor = value; }
        }
        /// <summary>
        /// 获取或者设置滚动条的箭头颜色
        /// </summary>
        [DefaultValue(typeof(Color), "White"), Category("ControlColor")]
        [Description("滚动条箭头的颜色")]
        public Color ScrollArrowColor
        {
            get { return VScroll.ArrowColor; }
            set { VScroll.ArrowColor = value; }
        }

        private Color arrowColor;
        /// <summary>
        /// 获取或者设置列表项箭头的颜色
        /// </summary>
        [DefaultValue(typeof(Color), "DarkGray"), Category("ControlColor")]
        [Description("列表项上面的箭头的颜色")]
        public Color ArrowColor
        {
            get { return arrowColor; }
            set
            {
                if (arrowColor == value) return;
                arrowColor = value;
                this.Invalidate();
            }
        }

        private Color itemColor;
        /// <summary>
        /// 获取或者设置列表项背景色
        /// </summary>
        [DefaultValue(typeof(Color), "White"), Category("ControlColor")]
        [Description("列表项的背景色")]
        public Color ItemColor
        {
            get { return itemColor; }
            set
            {
                if (itemColor == value) return;
                itemColor = value;
            }
        }

        private Color subItemColor;
        /// <summary>
        /// 获取或者设置子项的背景色
        /// </summary>
        [DefaultValue(typeof(Color), "White"), Category("ControlColor")]
        [Description("列表子项的背景色")]
        public Color SubItemColor
        {
            get { return subItemColor; }
            set
            {
                if (subItemColor == value) return;
                subItemColor = value;
            }
        }

        private Color itemMouseOnColor;
        /// <summary>
        /// 获取或者设置当鼠标移动到列表项的颜色
        /// </summary>
        [DefaultValue(typeof(Color), "LightYellow"), Category("ControlColor")]
        [Description("当鼠标移动到列表项上面的颜色")]
        public Color ItemMouseOnColor
        {
            get { return itemMouseOnColor; }
            set { itemMouseOnColor = value; }
        }

        private Color subItemMouseOnColor;
        /// <summary>
        /// 获取或者设置当鼠标移动到子项的颜色
        /// </summary>
        [DefaultValue(typeof(Color), "LightBlue"), Category("ControlColor")]
        [Description("当鼠标移动到子项上面的颜色")]
        public Color SubItemMouseOnColor
        {
            get { return subItemMouseOnColor; }
            set { subItemMouseOnColor = value; }
        }

        private Color subItemSelectColor;
        /// <summary>
        /// 获取或者设置选中的子项的颜色
        /// </summary>
        [DefaultValue(typeof(Color), "Wheat"), Category("ControlColor")]
        [Description("当列表子项被选中时候的颜色")]
        public Color SubItemSelectColor
        {
            get { return subItemSelectColor; }
            set { subItemSelectColor = value; }
        }

        #endregion

        #region 事件

        public delegate void PlayListEventHandler(object sender, ChatListEventArgs e);
        public event PlayListEventHandler DoubleClickSubItem;
        public event PlayListEventHandler MouseEnterHead;
        public event PlayListEventHandler MouseLeaveHead;

        protected virtual void OnDoubleClickSubItem(ChatListEventArgs e)
        {
            if (this.DoubleClickSubItem != null)
                DoubleClickSubItem(this, e);
        }

        protected virtual void OnMouseEnterHead(ChatListEventArgs e)
        {
            if (this.MouseEnterHead != null)
                MouseEnterHead(this, e);
        }

        protected virtual void OnMouseLeaveHead(ChatListEventArgs e)
        {
            if (this.MouseLeaveHead != null)
                MouseLeaveHead(this, e);
        }

        #endregion

        /// <summary>
        /// 鼠标位置
        /// </summary>
        private Point MousePos;             
        
        /// <summary>
        /// 滚动条
        /// </summary>
        private PlayListVScroll VScroll;

        /// <summary>
        /// 鼠标所在的列表
        /// </summary>
        private PlayList MouseOnList;

        /// <summary>
        /// 鼠标所在的歌曲项
        /// </summary>
        private SongItem MouseOnSongItem;

        /// <summary>
        /// 鼠标是否进入表头区域
        /// </summary>
        private bool OnMouseEnterHeaded;     

        /// <summary>
        /// 绘制
        /// </summary>
        /// <param name="e"></param>
        protected override void OnPaint(PaintEventArgs e)
        {
            Graphics g = e.Graphics;
            g.TranslateTransform(0, -VScroll.Value);        //根据滚动条的值设置坐标偏移
            Rectangle rectItem = new Rectangle(0, 1, this.Width, 25);                       //列表项区域
            Rectangle rectSubItem = new Rectangle(0, 26, this.Width, 55);    //子项区域
            SolidBrush sb = new SolidBrush(this.itemColor);
            try
            {
                for (int i = 0, lenItem = items.Count; i < lenItem; i++)
                {   
                    //绘制列表项
                    DrawList(g, items[i], rectItem, sb);        
                    if (items[i].IsOpen)
                    {                      
                        //如果列表项展开绘制子项
                        rectSubItem.Y = rectItem.Bottom + 1;
                        for (int j = 0, lenSubItem = items[i].SubItems.Count; j < lenSubItem; j++)
                        {
                            DrawSongItem(g, items[i].SubItems[j], ref rectSubItem, sb);  //绘制子项
                            rectSubItem.Y = rectSubItem.Bottom + 1;             //计算下一个子项的区域
                            rectSubItem.Height = 55;
                        }
                        rectItem.Height = rectSubItem.Bottom - rectItem.Top - 55 - 1;
                    }
                    items[i].Bounds = new Rectangle(rectItem.Location, rectItem.Size);
                    rectItem.Y = rectItem.Bottom + 1;           //计算下一个列表项区域
                    rectItem.Height = 25;
                }
                g.ResetTransform();             //重置坐标系
                VScroll.VirtualHeight = rectItem.Bottom - 26;   //绘制完成计算虚拟高度决定是否绘制滚动条
                if (VScroll.ShouldBeDraw)   //是否绘制滚动条
                    VScroll.ReDrawScroll(g);
            }
            finally { sb.Dispose(); }
            base.OnPaint(e);
        }

        protected override void OnCreateControl()
        {
            base.OnCreateControl();
        }

        protected override void OnMouseWheel(MouseEventArgs e)
        {
            if (e.Delta > 0) VScroll.Value -= 50;
            if (e.Delta < 0) VScroll.Value += 50;
            base.OnMouseWheel(e);
        }

        protected override void OnMouseDown(MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {        //如果左键在滚动条滑块上点击
                if (VScroll.SliderBounds.Contains(e.Location))
                {
                    VScroll.IsMouseDown = true;
                    VScroll.MouseDownY = e.Y;
                }
            }
            this.Focus();
            base.OnMouseDown(e);
        }

        protected override void OnMouseUp(MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
                VScroll.IsMouseDown = false;
            base.OnMouseUp(e);
        }

        protected override void OnMouseMove(MouseEventArgs e)
        {
            MousePos = e.Location;
            if (VScroll.IsMouseDown)
            {          
                //如果滚动条的滑块处于被点击 那么移动
                VScroll.MoveSliderFromLocation(e.Y);
                return;
            }
            if (VScroll.ShouldBeDraw)
            {        
                //如果控件上有滚动条 判断鼠标是否在滚动条区域移动
                if (VScroll.Bounds.Contains(MousePos))
                {
                    ClearItemMouseOn();
                    ClearSubItemMouseOn();
                    if (VScroll.SliderBounds.Contains(MousePos))
                        VScroll.IsMouseOnSlider = true;
                    else
                        VScroll.IsMouseOnSlider = false;
                    if (VScroll.UpBounds.Contains(MousePos))
                        VScroll.IsMouseOnUp = true;
                    else
                        VScroll.IsMouseOnUp = false;
                    if (VScroll.DownBounds.Contains(MousePos))
                        VScroll.IsMouseOnDown = true;
                    else
                        VScroll.IsMouseOnDown = false;
                    return;
                }
                else
                    VScroll.ClearAllMouseOn();
            }
            MousePos.Y += VScroll.Value;        
            
            //如果不在滚动条范围类 那么根据滚动条当前值计算虚拟的一个坐标
            for (int i = 0, Len = items.Count; i < Len; i++)
            {     
                //然后判断鼠标是否移动到某一列表项或者子项
                if (items[i].Bounds.Contains(MousePos))
                {
                    if (items[i].IsOpen)
                    {             
                        //如果展开 判断鼠标是否在某一子项上面
                        for (int j = 0, lenSubItem = items[i].SubItems.Count; j < lenSubItem; j++)
                        {
                            if (items[i].SubItems[j].Bounds.Contains(MousePos))
                            {
                                if (MouseOnSongItem != null)
                                {            
                                    //如果当前鼠标下子项不为空
                                    if (items[i].SubItems[j].HeadRect.Contains(MousePos))
                                    {     
                                        //判断鼠标是否在头像内
                                        if (!OnMouseEnterHeaded)
                                        {     
                                            //如果没有触发进入事件 那么触发用户绑定的事件
                                            OnMouseEnterHead(new ChatListEventArgs(this.MouseOnSongItem, this.selectSubItem));
                                            OnMouseEnterHeaded = true;
                                        }
                                    }
                                    else
                                    {
                                        if (OnMouseEnterHeaded)
                                        {       
                                            //如果已经执行过进入事件 那触发用户绑定的离开事件
                                            OnMouseLeaveHead(new ChatListEventArgs(this.MouseOnSongItem, this.selectSubItem));
                                            OnMouseEnterHeaded = false;
                                        }
                                    }
                                }
                                if (items[i].SubItems[j].Equals(MouseOnSongItem))
                                {
                                    return;
                                }
                                ClearSubItemMouseOn();
                                ClearItemMouseOn();
                                MouseOnSongItem = items[i].SubItems[j];
                                this.Invalidate(new Rectangle(
                                    MouseOnSongItem.Bounds.X, MouseOnSongItem.Bounds.Y - VScroll.Value,
                                    MouseOnSongItem.Bounds.Width, MouseOnSongItem.Bounds.Height));
                                //this.Invalidate();
                                return;
                            }
                        }
                        ClearSubItemMouseOn();      //循环做完没发现子项 那么判断是否在列表上面
                        if (new Rectangle(0, items[i].Bounds.Top - VScroll.Value, this.Width, 20).Contains(e.Location))
                        {
                            if (items[i].Equals(MouseOnList))
                                return;
                            ClearItemMouseOn();
                            MouseOnList = items[i];
                            this.Invalidate(new Rectangle(
                                MouseOnList.Bounds.X, MouseOnList.Bounds.Y - VScroll.Value,
                                MouseOnList.Bounds.Width, MouseOnList.Bounds.Height));
                            //this.Invalidate();
                            return;
                        }
                    }
                    else
                    {        //如果列表项没有展开 重绘列表项
                        if (items[i].Equals(MouseOnList))
                            return;
                        ClearItemMouseOn();
                        ClearSubItemMouseOn();
                        MouseOnList = items[i];
                        this.Invalidate(new Rectangle(
                                MouseOnList.Bounds.X, MouseOnList.Bounds.Y - VScroll.Value,
                                MouseOnList.Bounds.Width, MouseOnList.Bounds.Height));
                        //this.Invalidate();
                        return;
                    }
                }
            }//若循环结束 既不在列表上也不再子项上 清空上面的颜色
            ClearItemMouseOn();
            ClearSubItemMouseOn();
            base.OnMouseMove(e);
        }

        protected override void OnMouseLeave(EventArgs e)
        {
            ClearItemMouseOn();
            ClearSubItemMouseOn();
            VScroll.ClearAllMouseOn();
            if (OnMouseEnterHeaded)
            {        
                //如果已经执行过进入事件 那触发用户绑定的离开事件
                OnMouseLeaveHead(new ChatListEventArgs(this.MouseOnSongItem, this.selectSubItem));
                OnMouseEnterHeaded = false;
            }
            base.OnMouseLeave(e);
        }

        protected override void OnClick(EventArgs e)
        {
            if (VScroll.IsMouseDown) return;    //MouseUp事件触发在Click后 滚动条滑块为点下状态 单击无效
            if (VScroll.ShouldBeDraw)
            {         
                //如果有滚动条 判断是否在滚动条类点击
                if (VScroll.Bounds.Contains(MousePos))
                {        
                    //判断在滚动条那个位置点击
                    if (VScroll.UpBounds.Contains(MousePos))
                        VScroll.Value -= 50;
                    else if (VScroll.DownBounds.Contains(MousePos))
                        VScroll.Value += 50;
                    else if (!VScroll.SliderBounds.Contains(MousePos))
                        VScroll.MoveSliderToLocation(MousePos.Y);
                    return;
                }
            }
            //否则 如果在列表上点击 展开或者关闭 在子项上面点击则选中
            foreach (PlayList item in items)
            {
                if (item.Bounds.Contains(MousePos))
                {
                    if (item.IsOpen)
                    {
                        foreach (SongItem songitem in item.SubItems)
                        {
                            if (songitem.Bounds.Contains(MousePos))
                            {
                                if (songitem.Equals(selectSubItem))
                                    return;
                                selectSubItem = songitem;
                                this.Invalidate();
                                return;
                            }
                        }
                        if (new Rectangle(0, item.Bounds.Top, this.Width, 20).Contains(MousePos))
                        {
                            selectSubItem = null;
                            item.IsOpen = !item.IsOpen;
                            this.Invalidate();
                            return;
                        }
                    }
                    else
                    {
                        selectSubItem = null;
                        item.IsOpen = !item.IsOpen;
                        this.Invalidate();
                        return;
                    }
                }
            }
            base.OnClick(e);
        }

        protected override void OnDoubleClick(EventArgs e)
        {
            this.OnClick(e);        //双击时 再次触发一下单击事件  不然双击列表项 相当于只点击了一下列表项
            if (VScroll.Bounds.Contains(PointToClient(MousePosition))) return;  //如果双击在滚动条上返回
            if (this.selectSubItem != null)     //如果选中项不为空 那么触发用户绑定的双击事件
                OnDoubleClickSubItem(new ChatListEventArgs(this.MouseOnSongItem, this.selectSubItem));
            base.OnDoubleClick(e);
        }

        /// <summary>
        /// 绘制列表项
        /// </summary>
        /// <param name="g">绘图表面</param>
        /// <param name="list">要绘制的列表项</param>
        /// <param name="rectList">该列表项的区域</param>
        /// <param name="sb">画刷</param>
        protected virtual void DrawList(Graphics g, PlayList list, Rectangle rectList, SolidBrush sb)
        {
            if (list.Equals(MouseOnList))           //根据列表项现在的状态绘制相应的背景色
                sb.Color = this.itemMouseOnColor;
            else
                sb.Color = this.itemColor;
            g.FillRectangle(sb, rectList);

            //如果展开的画绘制 展开的三角形
            if (list.IsOpen)
            {
                sb.Color = this.arrowColor;
                g.FillPolygon(sb, new Point[] { 
                        new Point(2, rectList.Top + 11), 
                        new Point(12, rectList.Top + 11), 
                        new Point(7, rectList.Top + 16) });
            }
            else
            {
                sb.Color = this.arrowColor;
                g.FillPolygon(sb, new Point[] { 
                        new Point(5, rectList.Top + 8), 
                        new Point(5, rectList.Top + 18), 
                        new Point(10, rectList.Top + 13) });

                //如果没有展开则在列表项下部画分隔线
                g.DrawLine(new Pen(Color.LightGray, 1), 0, rectList.Bottom, rectList.Right, rectList.Bottom);
            }

            StringFormat sf = new StringFormat();
            sf.LineAlignment = StringAlignment.Center;
            sf.SetTabStops(0.0F, new float[] { 20.0F });
            string strItem = "\t" + list.Text;

            sf.Alignment = StringAlignment.Near;
            Font listTitleFont = new Font("宋体", 10, FontStyle.Bold);
            g.DrawString(strItem, listTitleFont, Brushes.Black, rectList, sf);

            float length = g.MeasureString(strItem, listTitleFont).Width;
            sf.SetTabStops(0.0f, new float[] {length-20 });
            g.DrawString("\t[" + list.SubItems.Count + "]", new Font("宋体", 9), Brushes.Gray, rectList, sf);

            //绘制菜单按钮
            if (VScroll.ShouldBeDraw)
            {
                list.MenuBounds = new Rectangle(rectList.Right - 25 - list.Menu.Width, rectList.Top + 5,list.Menu.Width, list.Menu.Height);
                g.DrawImage(list.Menu, list.MenuBounds);
            }
            else
            {
                list.MenuBounds = new Rectangle(rectList.Right - 25 - list.Menu.Width, rectList.Top + 5,list.Menu.Width, list.Menu.Height);
                g.DrawImage(list.Menu, list.MenuBounds);
            }
        }

        /// <summary>
        /// 绘制列表子项
        /// </summary>
        /// <param name="g">绘图表面</param>
        /// <param name="subItem">要绘制的子项</param>
        /// <param name="rectSubItem">该子项的区域</param>
        /// <param name="sb">画刷</param>
        protected virtual void DrawSongItem(Graphics g, SongItem subItem, ref Rectangle rectSubItem, SolidBrush sb)
        {
            if (subItem.Equals(selectSubItem))   //判断改子项是否被选中
            {
                rectSubItem.Height = 55;   //如果选中则绘制成大图标
                sb.Color = this.subItemSelectColor;
                g.FillRectangle(sb, rectSubItem);
                //DrawHeadImage(g, subItem, rectSubItem);         //绘制头像
                DrawPlayingSongItemm(g, subItem, rectSubItem);      //绘制大图标 显示的个人信息
                subItem.Bounds = new Rectangle(rectSubItem.Location, rectSubItem.Size);
                return;
            }
            else if (subItem.Equals(MouseOnSongItem))
                sb.Color = this.subItemMouseOnColor;
            else
                sb.Color = this.subItemColor;
            g.FillRectangle(sb, rectSubItem);
            //DrawHeadImage(g, subItem, rectSubItem);

            //if (iconSizeMode == IconSize.Large)         //没有选中则根据 图标模式绘制
            //    DrawPlayingSongItemm(g, subItem, rectSubItem);
            //else
                DrawNormalSongItem(g, subItem, rectSubItem);

            subItem.Bounds = new Rectangle(rectSubItem.Location, rectSubItem.Size);
        }

        
        /// <summary>
        /// 绘制歌手头像
        /// </summary>
        /// <param name="g">绘图表面</param>
        /// <param name="headRect">头像区域</param>
        /// <param name="headImage">头像</param>
        protected virtual void DrawHeadImage(Graphics g, Rectangle headRect,Bitmap headImage)
        {
            if (headImage==null)
            {
                
            }
            else
            {

            }

        }

        /// <summary>
        /// 绘制正常列表项
        /// </summary>
        /// <param name="g">绘图表面</param>
        /// <param name="songitem">要绘制信息的子项</param>
        /// <param name="rectSubItem">该子项的区域</param>
        protected virtual void DrawNormalSongItem(Graphics g, SongItem songitem, Rectangle rectSubItem)
        {
            rectSubItem.Height = 30;               //重新赋值一个高度
            StringFormat sf = new StringFormat();

            sf.LineAlignment = StringAlignment.Center;
            //sf.Alignment = StringAlignment.Center;
            sf.FormatFlags = StringFormatFlags.NoWrap;
            string strDraw = songitem.SongName;

            Size szFont = TextRenderer.MeasureText(strDraw, this.Font);
            sf.SetTabStops(0.0F, new float[] { rectSubItem.Height });
            g.DrawString("\t" + strDraw, this.Font, Brushes.Black, rectSubItem, sf);

            sf.SetTabStops(0.0F, new float[] { rectSubItem.Height + 5 + szFont.Width });
            sf.Alignment = StringAlignment.Far;
            g.DrawString(string.Format("\t{0:D2}:{1:D2}", + songitem.TotalTime/60,songitem.TotalTime%60), this.Font, Brushes.Gray, rectSubItem, sf);
        }

        /// <summary>
        /// 绘制正在播放的列表项
        /// </summary>
        /// <param name="g">绘图表面</param>
        /// <param name="songitem">要绘制信息的子项</param>
        /// <param name="rectSubItem">该子项的区域</param>
        protected virtual void DrawPlayingSongItemm(Graphics g, SongItem songitem, Rectangle rectSubItem)
        {
            g.FillRectangle(new SolidBrush(Color.FromArgb(101, 192, 244)), rectSubItem);
            rectSubItem.Height = 55;       //重新赋值一个高度
            StringFormat sf = new StringFormat();
            sf.Alignment = StringAlignment.Near;
            sf.LineAlignment = StringAlignment.Center;
            sf.SetTabStops(0.0f, new float[] { 2.0f + rectSubItem.Height + 10 });

            Rectangle rectContent = new Rectangle(rectSubItem.X, rectSubItem.Y, rectSubItem.Width, rectSubItem.Height / 2);
           
            g.DrawString("\t" + songitem.SongName, this.Font, new SolidBrush(Color.White),rectContent, sf);

            rectContent.Y += rectSubItem.Height / 2;
            g.DrawString(string.Format("\t{0:D2}:{1:D2}", songitem.TotalTime / 60, songitem.TotalTime % 60), this.Font, new SolidBrush(Color.White), rectContent, sf);
            
            //g.DrawImage(item.HeadImage, item.HeadRect);
            //item.TailRect = new Rectangle(rectItem.Right - 10 - item.TailButton.Width, rectItem.Top + 2,
            //    item.TailButton.Width, item.TailButton.Height);
            //g.DrawImage(item.TailButton, item.TailRect);

        }


        private void ClearItemMouseOn()
        {
            if (MouseOnList != null)
            {
                this.Invalidate(new Rectangle(
                    MouseOnList.Bounds.X, MouseOnList.Bounds.Y - VScroll.Value,
                    MouseOnList.Bounds.Width, MouseOnList.Bounds.Height));
                MouseOnList = null;
            }
        }

        private void ClearSubItemMouseOn()
        {
            if (MouseOnSongItem != null)
            {
                this.Invalidate(new Rectangle(
                    MouseOnSongItem.Bounds.X, MouseOnSongItem.Bounds.Y - VScroll.Value,
                    MouseOnSongItem.Bounds.Width, MouseOnSongItem.Bounds.Height));
                MouseOnSongItem = null;
            }
        }

        //自定义列表项集合
        public class PlayListItemCollection : IList, ICollection, IEnumerable
        {
            private int count;      //元素个数
            public int Count { get { return count; } }
            private PlayList[] m_arrItem;
            
            private PlayListBox owner;  //所属的控件

            public PlayListItemCollection(PlayListBox _owner) { this.owner = _owner; }
            //确认存储空间
            private void EnsureSpace(int elements)
            {
                if (m_arrItem == null)
                    m_arrItem = new PlayList[Math.Max(elements, 4)];
                else if (this.count + elements > m_arrItem.Length)
                {
                    PlayList[] arrTemp = new PlayList[Math.Max(this.count + elements, m_arrItem.Length * 2)];
                    m_arrItem.CopyTo(arrTemp, 0);
                    m_arrItem = arrTemp;
                }
            }

            /// <summary>
            /// 获取列表项所在的索引位置
            /// </summary>
            /// <param name="item">要获取的列表项</param>
            /// <returns>索引位置</returns>
            public int IndexOf(PlayList item)
            {
                return Array.IndexOf<PlayList>(m_arrItem, item);
            }

            /// <summary>
            /// 添加一个列表项
            /// </summary>
            /// <param name="item">要添加的列表项</param>
            public void Add(PlayList item)
            {
                if (item == null)       //空引用不添加
                    throw new ArgumentNullException("Item cannot be null");
                this.EnsureSpace(1);
                if (-1 == this.IndexOf(item))
                {         //进制添加重复对象
                    item.OwnerPlayListBox = this.owner;
                    m_arrItem[this.count++] = item;
                    this.owner.Invalidate();            //添加进去是 进行重绘
                }
            }

            /// <summary>
            /// 添加一个列表项的数组
            /// </summary>
            /// <param name="items">要添加的列表项的数组</param>
            public void AddRange(PlayList[] items)
            {
                if (items == null)
                    throw new ArgumentNullException("Items cannot be null");
                this.EnsureSpace(items.Length);
                try
                {
                    foreach (PlayList item in items)
                    {
                        if (item == null)
                            throw new ArgumentNullException("Item cannot be null");
                        if (-1 == this.IndexOf(item))
                        {     //重复数据不添加
                            item.OwnerPlayListBox = this.owner;
                            m_arrItem[this.count++] = item;
                        }
                    }
                }
                finally
                {
                    this.owner.Invalidate();
                }
            }

            /// <summary>
            /// 移除一个列表项
            /// </summary>
            /// <param name="item">要移除的列表项</param>
            public void Remove(PlayList item)
            {
                int index = this.IndexOf(item);
                if (-1 != index)        //如果存在元素 那么根据索引移除
                    this.RemoveAt(index);
            }

            /// <summary>
            /// 根据索引位置删除一个列表项
            /// </summary>
            /// <param name="index">索引位置</param>
            public void RemoveAt(int index)
            {
                if (index < 0 || index >= this.count)
                    throw new IndexOutOfRangeException("Index was outside the bounds of the array");
                this.count--;
                for (int i = index, Len = this.count; i < Len; i++)
                    m_arrItem[i] = m_arrItem[i + 1];
                this.owner.Invalidate();
            }

            /// <summary>
            /// 清空所有列表项
            /// </summary>
            public void Clear()
            {
                this.count = 0;
                m_arrItem = null;
                this.owner.Invalidate();
            }

            /// <summary>
            /// 根据索引位置插入一个列表项
            /// </summary>
            /// <param name="index">索引位置</param>
            /// <param name="item">要插入的列表项</param>
            public void Insert(int index, PlayList item)
            {
                if (index < 0 || index >= this.count)
                    throw new IndexOutOfRangeException("Index was outside the bounds of the array");
                if (item == null)
                    throw new ArgumentNullException("Item cannot be null");
                this.EnsureSpace(1);
                for (int i = this.count; i > index; i--)
                    m_arrItem[i] = m_arrItem[i - 1];
                item.OwnerPlayListBox = this.owner;
                m_arrItem[index] = item;
                this.count++;
                this.owner.Invalidate();
            }

            /// <summary>
            /// 判断一个列表项是否在集合内
            /// </summary>
            /// <param name="item">要判断的列表项</param>
            /// <returns>是否在列表项</returns>
            public bool Contains(PlayList item)
            {
                return this.IndexOf(item) != -1;
            }

            /// <summary>
            /// 将列表项的集合拷贝至一个数组
            /// </summary>
            /// <param name="array">目标数组</param>
            /// <param name="index">拷贝的索引位置</param>
            public void CopyTo(Array array, int index)
            {
                if (array == null)
                    throw new ArgumentNullException("array cannot be null");
                m_arrItem.CopyTo(array, index);
            }

            /// <summary>
            /// 根据索引获取一个列表项
            /// </summary>
            /// <param name="index">索引位置</param>
            /// <returns>列表项</returns>
            public PlayList this[int index]
            {
                get
                {
                    if (index < 0 || index >= this.count)
                        throw new IndexOutOfRangeException("Index was outside the bounds of the array");
                    return m_arrItem[index];
                }
                set
                {
                    if (index < 0 || index >= this.count)
                        throw new IndexOutOfRangeException("Index was outside the bounds of the array");
                    m_arrItem[index] = value;
                }
            }
            //实现接口
            int IList.Add(object value)
            {
                if (!(value is PlayList))
                    throw new ArgumentException("Value cannot convert to ListItem");
                this.Add((PlayList)value);
                return this.IndexOf((PlayList)value);
            }

            void IList.Clear()
            {
                this.Clear();
            }

            bool IList.Contains(object value)
            {
                if (!(value is PlayList))
                    throw new ArgumentException("Value cannot convert to ListItem");
                return this.Contains((PlayList)value);
            }

            int IList.IndexOf(object value)
            {
                if (!(value is PlayList))
                    throw new ArgumentException("Value cannot convert to ListItem");
                return this.IndexOf((PlayList)value);
            }

            void IList.Insert(int index, object value)
            {
                if (!(value is PlayList))
                    throw new ArgumentException("Value cannot convert to ListItem");
                this.Insert(index, (PlayList)value);
            }

            bool IList.IsFixedSize
            {
                get { return false; }
            }

            bool IList.IsReadOnly
            {
                get { return false; }
            }

            void IList.Remove(object value)
            {
                if (!(value is PlayList))
                    throw new ArgumentException("Value cannot convert to ListItem");
                this.Remove((PlayList)value);
            }

            void IList.RemoveAt(int index)
            {
                this.RemoveAt(index);
            }

            object IList.this[int index]
            {
                get { return this[index]; }
                set
                {
                    if (!(value is PlayList))
                        throw new ArgumentException("Value cannot convert to ListItem");
                    this[index] = (PlayList)value;
                }
            }

            void ICollection.CopyTo(Array array, int index)
            {
                this.CopyTo(array, index);
            }

            int ICollection.Count
            {
                get { return this.count; }
            }

            bool ICollection.IsSynchronized
            {
                get { return true; }
            }

            object ICollection.SyncRoot
            {
                get { return this; }
            }

            IEnumerator IEnumerable.GetEnumerator()
            {
                for (int i = 0, Len = this.count; i < Len; i++)
                    yield return m_arrItem[i];
            }
        }
    }
}
