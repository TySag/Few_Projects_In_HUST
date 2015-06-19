using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel;
using System.Windows.Forms;
using System.Drawing;

namespace MediaControlLibrary
{
    public class MediaList
    {
        private MediaContainer _ownerContainer;
        /// <summary>
        /// 列表项所在的媒体容器
        /// </summary>
        public MediaContainer OwnerContainer
        {
            get { return _ownerContainer; }
            set { _ownerContainer = value; }
        }

        private MediaItemCollection _subItems;
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Content)]
        public MediaItemCollection SubItems
        {
            get
            {
                if (_subItems == null)
                    _subItems = new MediaItemCollection(this);
                return _subItems;
            }
        }

        private string _title;
        /// <summary>
        /// 列表项标题
        /// </summary>
        public string Title
        {
            get { return _title; }
            set { _title = value; }
        }

        private bool _isOpen;
        /// <summary>
        /// 指示列表项是否打开
        /// </summary>
        [DefaultValue(typeof(bool),"false")]
        public bool IsOpen
        {
            get { return _isOpen; }
            set
            {
                _isOpen = value;
                this._ownerContainer.Invalidate();
            }
        }

        private Rectangle _clipBounds;
        /// <summary>
        /// 列表项的显示区域
        /// </summary>
        public Rectangle ClipBounds
        {
            get { return _clipBounds; }
            set { _clipBounds = value; }
        }

        private Rectangle _menuBounds;
        /// <summary>
        /// 列表项菜单按钮的显示区域
        /// </summary>
        public Rectangle MenuBounds
        {
            get { return _menuBounds; }
            set { _menuBounds = value; }
        }

        /// <summary>
        /// 列表项的菜单按钮显示的图片
        /// </summary>
        public Image Menu
        {
            get
            {
                if (_isMouseOnMenu)
                {
                    return global::MediaControlLibrary.Properties.Resources.mediaitemsmenu_Light;
                }
                if (_isMouseDownMenu)
                {
                    return global::MediaControlLibrary.Properties.Resources.mediaitemsmenu_Dark;
                }
                return global::MediaControlLibrary.Properties.Resources.mediaitemsmenu_;
            }
        }

        private bool _isMouseOnMenu=false;
        public bool IsMouseOnMenu
        {
            get { return _isMouseOnMenu; }
            set { _isMouseOnMenu = value; }
        }

        private bool _isMouseDownMenu=false;
        public bool IsMouseDownMenu
        {
            get { return _isMouseDownMenu; }
            set { _isMouseDownMenu = value; }
        }
        
        public MediaList()
        {
            if (this._title == null)
                this._title = string.Empty;
            if (_subItems == null)
                _subItems = new MediaItemCollection(this);
        }

        public MediaList(string title)
        {
            this._title = title;
            if (_subItems == null)
                _subItems = new MediaItemCollection(this);
        }

        public MediaList(string title, bool bOpen)
        {
            this._title = title;
            this._isOpen = bOpen;
            if (_subItems == null)
                _subItems = new MediaItemCollection(this);
        }

        public MediaList(MediaItem[] items)
        {
            if (_subItems == null)
                _subItems = new MediaItemCollection(this);
            this._subItems.AddRange(items);
        }

        public MediaList(string title, MediaItem[] items)
        {
            this._title = title;
            if (_subItems == null)
                _subItems = new MediaItemCollection(this);
            this._subItems.AddRange(items);
        }

        public MediaList(string title, bool bOpen, MediaItem[] items)
        {
            this._title = title;
            this._isOpen = bOpen;
            if (_subItems == null)
                _subItems = new MediaItemCollection(this);
            this._subItems.AddRange(items);
        }

        public void FindItemByKey(string key)
        {
            if (_subItems != null)
                _subItems.FindItemByKey(key);
        }
    }
}
