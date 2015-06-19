using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.Windows.Forms;

namespace PlaylistBox
{
    internal class PlayListVScroll
    {
        /// <summary>
        /// 滚动条宽度
        /// </summary>
        private int scrollWidth;
        public int ScrollWidth
        {
            get { return scrollWidth; }
        }

        /// <summary>
        /// 滚动条自身的区域
        /// </summary>
        private Rectangle bounds;
        public Rectangle Bounds
        {
            get { return bounds; }
        }

        /// <summary>
        /// 上边箭头区域
        /// </summary>
        private Rectangle upBounds;
        public Rectangle UpBounds
        {
            get { return upBounds; }
        }

        /// <summary>
        /// 下边箭头区域
        /// </summary>
        private Rectangle downBounds;
        public Rectangle DownBounds
        {
            get { return downBounds; }
        }

        /// <summary>
        /// 滑块区域
        /// </summary>
        private Rectangle sliderBounds;
        public Rectangle SliderBounds
        {
            get { return sliderBounds; }
        }

        /// <summary>
        /// 背景色
        /// </summary>
        private Color backColor;
        public Color BackColor
        {
            get { return backColor; }
            set { backColor = value; }
        }

        /// <summary>
        /// 滑块默认颜色
        /// </summary>
        private Color sliderDefaultColor;
        public Color SliderDefaultColor
        {
            get { return sliderDefaultColor; }
            set
            {
                if (sliderDefaultColor == value)
                    return;
                sliderDefaultColor = value;
                ctrl.Invalidate(this.sliderBounds);
            }
        }

        private Color sliderDownColor;
        /// <summary>
        /// 鼠标移入滑块时滑块的颜色
        /// </summary>
        public Color SliderDownColor
        {
            get { return sliderDownColor; }
            set
            {
                if (sliderDownColor == value)
                    return;
                sliderDownColor = value;
                ctrl.Invalidate(this.sliderBounds);
            }
        }

        private Color arrowColor;
        /// <summary>
        /// 箭头色
        /// </summary>
        public Color ArrowColor
        {
            get { return arrowColor; }
            set
            {
                if (arrowColor == value)
                    return;
                arrowColor = value;
                ctrl.Invalidate(this.bounds);
            }
        }

        private Color arrowMouseOnColor;
        /// <summary>
        /// 鼠标移入箭头时箭头显示的颜色
        /// </summary>
        public Color ArrowMouseOnColor
        {
            get { return arrowMouseOnColor; }
            set { arrowMouseOnColor = value; }
        }

        private Control ctrl;
        /// <summary>
        /// 绑定的控件
        /// </summary>
        public Control Ctrl
        {
            get { return ctrl; }
            set { ctrl = value; }
        }

        private int virtualHeight;
        /// <summary>
        /// 虚拟的一个高度(控件中内容的高度)
        /// </summary>
        public int VirtualHeight
        {
            get { return virtualHeight; }
            set
            {
                if (value <= ctrl.Height)
                {
                    if (shouldBeDraw == false)
                        return;
                    shouldBeDraw = false;
                    if (this.value != 0)
                    {
                        this.value = 0;
                        ctrl.Invalidate();
                    }
                }
                else
                {
                    shouldBeDraw = true;
                    if (value - this.value < ctrl.Height)
                    {
                        this.value -= ctrl.Height - value + this.value;
                        ctrl.Invalidate();
                    }
                }
                virtualHeight = value;
            }
        }

        //当前滚动条位置
        private int value;
        public int Value
        {
            get { return value; }
            set
            {
                if (!shouldBeDraw)
                    return;
                if (value < 0)
                {
                    if (this.value == 0)
                        return;
                    this.value = 0;
                    ctrl.Invalidate();
                    return;
                }
                if (value > virtualHeight - ctrl.Height)
                {
                    if (this.value == virtualHeight - ctrl.Height)
                        return;
                    this.value = virtualHeight - ctrl.Height;
                    ctrl.Invalidate();
                    return;
                }
                this.value = value;
                ctrl.Invalidate();
            }
        }

        //是否有必要在控件上绘制滚动条
        private bool shouldBeDraw;
        public bool ShouldBeDraw
        {
            get { return shouldBeDraw; }
        }

        private bool isMouseDown;
        /// <summary>
        /// 鼠标按下
        /// </summary>
        public bool IsMouseDown
        {
            get { return isMouseDown; }
            set
            {
                if (value)
                {
                    m_nLastSliderY = sliderBounds.Y;
                }
                isMouseDown = value;
            }
        }

        private bool isMouseOnSlider;
        /// <summary>
        /// 鼠标位于滑块上
        /// </summary>
        public bool IsMouseOnSlider
        {
            get { return isMouseOnSlider; }
            set
            {
                if (isMouseOnSlider == value)
                    return;
                isMouseOnSlider = value;
                ctrl.Invalidate(this.SliderBounds);
            }
        }

        private bool isMouseOnUp;
        /// <summary>
        /// 鼠标位于上箭头
        /// </summary>
        public bool IsMouseOnUp
        {
            get { return isMouseOnUp; }
            set
            {
                if (isMouseOnUp == value)
                    return;
                isMouseOnUp = value;
                ctrl.Invalidate(this.UpBounds);
            }
        }

        private bool isMouseOnDown;
        /// <summary>
        /// 鼠标位于下箭头
        /// </summary>
        public bool IsMouseOnDown
        {
            get { return isMouseOnDown; }
            set
            {
                if (isMouseOnDown == value)
                    return;
                isMouseOnDown = value;
                ctrl.Invalidate(this.DownBounds);
            }
        }

        private int mouseDownY;
        /// <summary>
        /// 鼠标在滑块点下时候的y坐标
        /// </summary>
        public int MouseDownY
        {
            get { return mouseDownY; }
            set { mouseDownY = value; }
        }

        /// <summary>
        /// 滑块移动前的 滑块的y坐标
        /// </summary>
        private int m_nLastSliderY;

        public PlayListVScroll(Control c)
        {
            this.ctrl = c;
            virtualHeight = 400;
            scrollWidth = 10;
            bounds = new Rectangle(0, 0, scrollWidth, 10);
            upBounds = new Rectangle(0, 0, scrollWidth, 8);
            downBounds = new Rectangle(0, 0, scrollWidth, 8);
            sliderBounds = new Rectangle(0, 0, 8, 8);
            this.backColor = Color.White;
            this.sliderDefaultColor = Color.DarkGray;
            this.sliderDownColor = Color.Gray;
            this.arrowColor = Color.Red;
            this.arrowMouseOnColor = Color.Black;
        }

        public void ClearAllMouseOn()
        {
            if (!this.isMouseOnDown && !this.isMouseOnSlider && !this.isMouseOnUp)
                return;
            this.isMouseOnDown =
                this.isMouseOnSlider =
                this.isMouseOnUp = false;
            ctrl.Invalidate(this.bounds);
        }

        //将滑块跳动至一个地方
        public void MoveSliderToLocation(int nCurrentMouseY)
        {
            if (nCurrentMouseY - sliderBounds.Height / 2 < 11)
                sliderBounds.Y = 11;
            else if (nCurrentMouseY + sliderBounds.Height / 2 > ctrl.Height - 11)
                sliderBounds.Y = ctrl.Height - sliderBounds.Height - 11;
            else
                sliderBounds.Y = nCurrentMouseY - sliderBounds.Height / 2;
            this.value = (int)((double)(sliderBounds.Y - 11) / (ctrl.Height - 22 - SliderBounds.Height) * (virtualHeight - ctrl.Height));
            ctrl.Invalidate();
        }

        /// <summary>
        /// 根据鼠标位置移动滑块
        /// </summary>
        /// <param name="nCurrentMouseY"></param>
        public void MoveSliderFromLocation(int nCurrentMouseY)
        {
            //if (!this.IsMouseDown) return;
            if (m_nLastSliderY + nCurrentMouseY - mouseDownY < 11)
            {
                if (sliderBounds.Y == 11)
                    return;
                sliderBounds.Y = 11;
            }
            else if (m_nLastSliderY + nCurrentMouseY - mouseDownY > ctrl.Height - 11 - SliderBounds.Height)
            {
                if (sliderBounds.Y == ctrl.Height - 11 - sliderBounds.Height)
                    return;
                sliderBounds.Y = ctrl.Height - 11 - sliderBounds.Height;
            }
            else
            {
                sliderBounds.Y = m_nLastSliderY + nCurrentMouseY - mouseDownY;
            }
            this.value = (int)((double)(sliderBounds.Y - 11) / (ctrl.Height - 22 - SliderBounds.Height) * (virtualHeight - ctrl.Height));
            ctrl.Invalidate();
        }

        /// <summary>
        /// 绘制滚动条
        /// </summary>
        /// <param name="g"></param>
        public void ReDrawScroll(Graphics g)
        {
            if (!shouldBeDraw)
                return;
            bounds.X = ctrl.Width - bounds.Width;
            bounds.Height = ctrl.Height;
            upBounds.X = downBounds.X = bounds.X;
            downBounds.Y = ctrl.Height - downBounds.Height;
            //计算滑块位置
            sliderBounds.X = bounds.X + 1;
            sliderBounds.Height = (int)(((double)ctrl.Height / virtualHeight) * (ctrl.Height - 22));
            if (sliderBounds.Height < 3) sliderBounds.Height = 3;
            sliderBounds.Y = 11 + (int)(((double)value / (virtualHeight - ctrl.Height)) * (ctrl.Height - 22 - sliderBounds.Height));
            SolidBrush sb = new SolidBrush(this.backColor);
            try
            {
                g.FillRectangle(sb, bounds);
                DrawArrow(g, this.UpBounds, new SolidBrush(Color.Gray), true);
                DrawArrow(g, this.DownBounds, new SolidBrush(Color.Gray), false);

                if (this.isMouseDown || this.isMouseOnSlider)
                    sb.Color = this.sliderDownColor;
                else
                    sb.Color = this.sliderDefaultColor;
                g.FillRectangle(sb, sliderBounds);
                sb.Color = this.arrowColor;
                if (this.isMouseOnUp)
                {
                    DrawArrow(g, this.UpBounds, new SolidBrush(arrowMouseOnColor), true);
                }
                if (this.isMouseOnDown)
                {
                    DrawArrow(g, this.DownBounds, new SolidBrush(arrowMouseOnColor), false);
                }
            }
            finally
            {
                sb.Dispose();
            }
        }

        /// <summary>
        /// 绘制箭头
        /// </summary>
        /// <param name="g"></param>
        /// <param name="arrowRect"></param>
        /// <param name="brush"></param>
        /// <param name="isUp"></param>
        private void DrawArrow(Graphics g, Rectangle arrowRect, Brush brush, bool isUp)
        {
            if (isUp)
            {
                g.FillPolygon(brush, new Point[]{
                new Point(arrowRect.Left+arrowRect.Width/2,arrowRect.Top+3),
                new Point(arrowRect.Left+1,arrowRect.Top+7),
                new Point(arrowRect.Right-1,arrowRect.Top+7)});
            }
            else
            {
                g.FillPolygon(brush, new Point[]{
                new Point(arrowRect.Left+1,arrowRect.Bottom-7),
                new Point(arrowRect.Right-1,arrowRect.Bottom-7),
                new Point(arrowRect.Left+arrowRect.Width/2,arrowRect.Bottom-3)});
            }
        }

    }
}
