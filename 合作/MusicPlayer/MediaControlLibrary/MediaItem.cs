using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;

namespace MediaControlLibrary
{
    public class MediaItem:IComparable
    {
        int IComparable.CompareTo(object obj)
        {
            if (!(obj is MediaItem))
            {
                throw new ArgumentException("obj is not a MediaItem");
            }
            return CompareTo((MediaItem)obj);
        }

        private MediaList _ownerList;
        /// <summary>
        /// 媒体项所在的列表项
        /// </summary>
        public MediaList OwnerList
        {
            get { return _ownerList; }
            set { _ownerList = value; }
        }

        private string _firstContent;
        /// <summary>
        /// 中间内容
        /// </summary>
        public string FirstContent
        {
            get { return _firstContent; }
            set { _firstContent = value; }
        }

        private string _secondContent;
        /// <summary>
        /// 尾部内容
        /// </summary>
        public string SecondContent
        {
            get { return _secondContent; }
            set { _secondContent = value; }
        }

        private Image _headImage=global::MediaControlLibrary.Properties.Resources.header_null_;
        /// <summary>
        /// 播放时头部显示的图片
        /// </summary>
        public Image HeadImage
        {
            get { return _headImage; }
            set { _headImage = value; }
        }

        private Rectangle _headRect;
        /// <summary>
        /// 头部显示的图片或按钮所在的区域
        /// </summary>
        public Rectangle HeadRect
        {
            get { return _headRect; }
            set { _headRect = value; }
        }

        private Rectangle _tailRect;
        /// <summary>
        /// 尾部按钮所在的区域
        /// </summary>
        public Rectangle TailRect
        {
            get { return _tailRect; }
            set { _tailRect = value; }
        }

        private Image _headButton=global::MediaControlLibrary.Properties.Resources.play_20;
        /// <summary>
        /// 头部按钮显示的图片
        /// </summary>
        public Image HeadButton
        {
            get
            {
                Bitmap bmp = (Bitmap)_headButton.Clone();
                Bitmap des = (Bitmap)_headButton.Clone();
                if (_isMouseOnHeadButton)
                    des = ImageProcess.BorderImage(bmp, 2);
                if (_isMouseDownHeadButton)
                    des = ImageProcess.WhiteToGray(bmp);
                return des;
            }
        }

        private Image _tailButton=global::MediaControlLibrary.Properties.Resources.dustbin_20;
        /// <summary>
        /// 尾部按钮显示的图片
        /// </summary>
        public Image TailButton
        {
            get
            {
                Bitmap bmp = (Bitmap)_tailButton.Clone();
                Bitmap des = (Bitmap)_tailButton.Clone();
                if (_isMouseOnTail)
                    des = ImageProcess.BorderImage(bmp, 2);
                if (_isMouseDownTail)
                    des = ImageProcess.WhiteToGray(bmp);
                return des;
            }
        }

        private Rectangle _clipBounds;
        /// <summary>
        /// 媒体项所在的区域
        /// </summary>
        public Rectangle ClipBounds
        {
            get { return _clipBounds; }
            set { _clipBounds = value; }
        }

        private bool _isPlaying;
        /// <summary>
        /// 媒体项是否正在播放
        /// </summary>
        public bool IsPlaying
        {
            get { return _isPlaying; }
            set { _isPlaying = value; }
        }

        private bool _isMouseOnHeadButton;
        public bool IsMouseOnHeadButton
        {
            get { return _isMouseOnHeadButton; }
            set { _isMouseOnHeadButton = value; }
        }

        private bool _isMouseDownHeadButton;

        public bool IsMouseDownHeadbutton
        {
            get { return _isMouseDownHeadButton; }
            set { _isMouseDownHeadButton = value; }
        }

        private bool _isMouseOnTail;
        public bool IsMouseOnTail
        {
            get { return _isMouseOnTail; }
            set { _isMouseOnTail = value; }
        }

        private bool _isMouseDownTail;

        public bool IsMouseDownTail
        {
            get { return _isMouseDownTail; }
            set { _isMouseDownTail = value; }
        }

        public int Index
        {
            get
            {
                return this._ownerList.SubItems.IndexOf(this);
            }
        }

        public int CompareTo(MediaItem item)
        {
            return _firstContent.CompareTo(item.FirstContent);
        }

        public void ReDrawMediaItem()
        {
            if (this._ownerList != null)
            {
                if (this._ownerList.OwnerContainer != null)
                    this._ownerList.OwnerContainer.Invalidate(this._clipBounds);
            }
        }

        public void ClearMouseHead()
        {
            if (_isMouseOnHeadButton)
                _isMouseOnHeadButton = !_isMouseOnHeadButton;
            if (_isMouseDownHeadButton)
                _isMouseDownHeadButton = !_isMouseDownHeadButton;
        }

        public void ClearMouseTail()
        {
            if (_isMouseOnTail)
                _isMouseOnTail = !_isMouseOnTail;
            if (_isMouseDownTail)
                _isMouseDownTail = !_isMouseDownTail;
        }

        public MediaItem(string firstContent, string secondContent)
        {
            this._firstContent = firstContent;
            this._secondContent = secondContent;
        }
    }
}
