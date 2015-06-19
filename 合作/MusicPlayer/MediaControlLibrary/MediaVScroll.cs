using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;
using System.Windows.Forms;

namespace MediaControlLibrary
{
    public class MediaVScroll
    {
        private Control _ownerControl;
        /// <summary>
        /// 需要被绑定的控件
        /// </summary>
        public Control OwnerControl
        {
            get { return _ownerControl; }
            set { _ownerControl = value; }
        }

        private Rectangle _clipBounds;
        /// <summary>
        /// 整个滚动条的区域
        /// </summary>
        public Rectangle ClipBounds
        {
            get { return _clipBounds; }
        }

        private Rectangle _slider;
        /// <summary>
        /// 有滑块时滑块的区域
        /// </summary>
        public Rectangle Slider
        {
            get { return _slider; }
        }

        private Rectangle _upArrow;
        /// <summary>
        /// 上箭头所在的区域
        /// </summary>
        public Rectangle UpArrow
        {
            get { return _upArrow; }
        }

        private Rectangle _downArrow;
        /// <summary>
        /// 下箭头所在的区域
        /// </summary>
        public Rectangle DownArrow
        {
            get { return _downArrow; }
        }

        private Color _sliderColor;
        /// <summary>
        /// 滑块的颜色
        /// </summary>
        public Color SliderColor
        {
            get { return _sliderColor; }
            set
            {
                if (_sliderColor == value)
                    return;
                _sliderColor = value;
                this._ownerControl.Invalidate(this._slider);
            }
        }

        private Color _sliderMouseOnColor;
        /// <summary>
        /// 鼠标移入滑块时滑块的颜色
        /// </summary>
        public Color SliderMouseOnColor
        {
            get { return _sliderMouseOnColor; }
            set { _sliderMouseOnColor = value; }
        }

        private Color _backColor;
        /// <summary>
        /// 整个滚动条的背景色
        /// </summary>
        public Color BackColor
        {
            get { return _backColor; }
            set
            {
                if (_backColor == value)
                    return;
                _backColor = value;
                this._ownerControl.Invalidate(this._clipBounds);
            }
        }

        private Color _arrowColor;
        /// <summary>
        /// 箭头显示的颜色
        /// </summary>
        public Color ArrowColor
        {
            get { return _arrowColor; }
            set
            {
                if (_arrowColor == value)
                    return;
                _arrowColor = value;
                this._ownerControl.Invalidate(this._upArrow);
                this._ownerControl.Invalidate(this._downArrow);
            }
        }

        private Color _arrowMouseOnColor;
        /// <summary>
        /// 鼠标移入箭头时箭头显示的颜色
        /// </summary>
        public Color ArrowMouseOnColor
        {
            get { return _arrowMouseOnColor; }
            set { _arrowMouseOnColor = value; }
        }

        private bool shouldBeDraw;
        /// <summary>
        /// 判断是否需要重绘
        /// </summary>
        public bool ShouldBeDraw
        {
            get { return shouldBeDraw; }
        }

        private bool _isMouseOnUp;
        /// <summary>
        /// 判断鼠标是否在上箭头
        /// </summary>
        public bool IsMouseOnUp
        {
            get { return _isMouseOnUp; }
            set
            {
                if (_isMouseOnUp == value)
                    return;
                _isMouseOnUp = value;
                this._ownerControl.Invalidate(this._upArrow);
            }
        }

        private bool _isMouseOnDown;
        /// <summary>
        /// 判断鼠标是否在下箭头
        /// </summary>
        public bool IsMouseOnDown
        {
            get { return _isMouseOnDown; }
            set
            {
                if (_isMouseOnDown == value)
                    return;
                _isMouseOnDown = value;
                this._ownerControl.Invalidate(this._downArrow);
            }
        }

        private bool _isMouseOnSlider;
        /// <summary>
        /// 判断是鼠标是否在滑块上
        /// </summary>
        public bool IsMouseOnSlider
        {
            get { return _isMouseOnSlider; }
            set
            {
                if (_isMouseOnSlider==value)
                    return;
                _isMouseOnSlider = value;
                this._ownerControl.Invalidate(this._slider);
            }
        }

        private bool _isDown;
        /// <summary>
        /// 判断滑块是否被单击
        /// </summary>
        public bool IsDown
        {
            get { return _isDown; }
            set
            {
                if (value)
                {
                    nLastSliderY = _slider.Y;
                }
                _isDown = value;
            }
        }

        private int _contentHeight;
        /// <summary>
        /// 绑定控件中内容的高度
        /// </summary>
        public int ContentHeight
        {
            get { return _contentHeight; }
            set
            {
                if (value > _ownerControl.Height)
                {
                    shouldBeDraw = true;
                    if (value - this._value < _ownerControl.Height)
                    {
                        this._value -= _ownerControl.Height - value + this._value;
                        this._ownerControl.Invalidate();
                    }
                    this._ownerControl.Invalidate();
                }
                else
                {
                    if (shouldBeDraw == false)
                        return;
                    shouldBeDraw = false;
                    if (this._value != 0)
                        this._value = 0;
                    this._ownerControl.Invalidate();
                }
                _contentHeight=value;
            }
        }

        private int _value;
        /// <summary>
        /// 滑块所在的位置
        /// </summary>
        public int Value
        {
            get { return _value; }
            set
            {
                if (!shouldBeDraw)
                    return;
                _value = value;
                if (_value < 0)
                {
                    _value = 0;
                    this._ownerControl.Invalidate();            //根据滑块位置确定容器中的内容并绘制
                    return;
                }
                if (_value >= _contentHeight - _ownerControl.Height)
                {
                    if (_value == _contentHeight - _ownerControl.Height)
                        return;
                    _value = _contentHeight - _ownerControl.Height;
                    this._ownerControl.Invalidate();
                    return;
                }
                this._ownerControl.Invalidate();
            }
        }

        private int nLastSliderY;
        private int _mouseDownY;
        /// <summary>
        /// 鼠标点下时的Y坐标
        /// </summary>
        public int MouseDownY
        {
            get { return _mouseDownY; }
            set { _mouseDownY = value; }
        }

        public MediaVScroll(Control ctrl)
        {
            this._ownerControl = ctrl;
            this._contentHeight = ctrl.Height;
            this._clipBounds = new Rectangle(ctrl.Right - 10, ctrl.Top, 10, ctrl.Height);
            this._upArrow = new Rectangle(_clipBounds.Right-10,_clipBounds.Top,10,8);
            this._downArrow = new Rectangle(_clipBounds.Right-10,_clipBounds.Bottom-8,10,8);
            this._backColor = Color.White;
            this._arrowColor = Color.LightGray;
            this._arrowMouseOnColor = Color.Black;
            this._sliderColor = Color.DarkGray;
            this._sliderMouseOnColor = Color.Gray;
        }

        /// <summary>
        /// 清空滚动条上的显示特效
        /// </summary>
        public void ClearAllMouseOn()
        {
            if (!this._isMouseOnDown && !this._isMouseOnSlider && !this._isMouseOnUp)
                return;
            this._isMouseOnUp =
                this._isMouseOnSlider =
                this._isMouseOnDown = false;
            this._ownerControl.Invalidate(this._clipBounds);
        }

        /// <summary>
        /// 绘制滚动条
        /// </summary>
        /// <param name="g"></param>
        public void ReDrawScroll(Graphics g)
        {
            if (!shouldBeDraw)
                return;
            _clipBounds.X = _ownerControl.ClientRectangle.Right - 10-1;
            _clipBounds.Y = _ownerControl.ClientRectangle.Top;
            _clipBounds.Height = _ownerControl.Height;
            _clipBounds.Width = 10;
            _upArrow.X = _downArrow.X = _clipBounds.X;
            _upArrow.Y = _clipBounds.Top;
            _upArrow.Width = _downArrow.Width = 10;
            _upArrow.Height = _downArrow.Height =8;
            _downArrow.Y = _clipBounds.Bottom-8;
            _slider.Width = 10;
            _slider.Height = (int)((double)_ownerControl.Height / _contentHeight * (_ownerControl.Height - 18));
            if (_slider.Height < 3)
                _slider.Height = 3;
            _slider.X = _clipBounds.X;
            //滑块的位置
            _slider.Y = 9 + (int)((double)_value / (_contentHeight -_ownerControl.Height)* 
                (_ownerControl.Height - 18 - _slider.Height));
            SolidBrush brush = new SolidBrush(this._backColor);
            try
            {
                g.FillRectangle(brush, this._clipBounds);
                brush.Color=this._arrowColor;
                DrawArrow(g, this._upArrow, brush, true);
                DrawArrow(g, this._downArrow, brush, false);
                if (this._isDown || this._isMouseOnSlider)
                    brush.Color = this._sliderMouseOnColor;
                else
                    brush.Color = this._sliderColor;
                g.FillRectangle(brush, _slider);
                if (this._isMouseOnUp)
                {
                    brush.Color = this._arrowMouseOnColor;
                    DrawArrow(g, this._upArrow, brush, true);
                }
                if(this._isMouseOnDown)
                {
                    brush.Color = this._arrowMouseOnColor;
                    DrawArrow(g, this._downArrow, brush, false);
                }
            }
            finally
            {
                brush.Dispose();
            }
        }

        private void DrawArrow(Graphics g, Rectangle arrowRect,Brush brush,bool isUp)
        {
            if (isUp)
            {
                g.FillPolygon(brush, new Point[]{
                new Point(arrowRect.Left+5,arrowRect.Top+3),
                new Point(arrowRect.Left+1,arrowRect.Top+7),
                new Point(arrowRect.Left+9,arrowRect.Top+7)});
            }
            else
            {
                g.FillPolygon(brush, new Point[]{
                new Point(arrowRect.Left+1,arrowRect.Top+3),
                new Point(arrowRect.Left+9,arrowRect.Top+3),
                new Point(arrowRect.Left+5,arrowRect.Top+7)});
            }
        }

        /// <summary>
        /// 根据Y位置移动滑块
        /// </summary>
        /// <param name="nCurrentY"></param>
        public void MoveSliderToLocation(int nCurrentY)
        {
            if (nCurrentY - _slider.Height / 2 < _upArrow.Bottom + 1)
                _slider.Y = _upArrow.Bottom + 1;
            else if (nCurrentY + _slider.Height / 2 > _downArrow.Top - 1 - _slider.Height)
                _slider.Y = _downArrow.Top - 1 - _slider.Height;
            else
                _slider.Y = nCurrentY + _slider.Height / 2;
            this._value = (int)((double)(_slider.Y - _upArrow.Bottom-1) * (_contentHeight-_ownerControl.Height) / 
                (_ownerControl.Height - 18 - _slider.Height));
            this._ownerControl.Invalidate();
        }

        /// <summary>
        /// 根据鼠标位置移动滑块
        /// </summary>
        /// <param name="nMouseY"></param>
        public void MoveSliderFromMouseY(int nMouseY)
        {
            if (nMouseY + nLastSliderY - _mouseDownY < _upArrow.Bottom+1)
            {
                if (this._slider.Y == _upArrow.Bottom+1)
                    return;
                this._slider.Y = _upArrow.Bottom+1;
            }
            else if (nMouseY + nLastSliderY - _mouseDownY > _downArrow.Top-1-_slider.Height)
            {
                if (this._slider.Y == _downArrow.Top - 1 - _slider.Height)
                    return;
                this._slider.Y = _downArrow.Top - 1 - _slider.Height;
            }
            else
                this._slider.Y = nMouseY + nLastSliderY - _mouseDownY;
            this._value = (int)((double)(_slider.Y - _upArrow.Bottom-1) * (_contentHeight-_ownerControl.Height) /
                (_ownerControl.Height - 18 - _slider.Height));
            this._ownerControl.Invalidate();
        }

        
    }
}
